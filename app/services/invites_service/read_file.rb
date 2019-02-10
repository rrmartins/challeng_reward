require './lib/invites/formatted_row'

module InvitesService
  class ReadFile
    attr_accessor :file, :data_file, :errors

    KEYWORDS ||= %w[accepts recommends].freeze
    EXTENSIONS_ALLOWS ||= %w[txt].freeze
    DATE_FORMAT_LENGTH ||= 16

    def initialize(file)
      @file = file
    end

    def self.call(file)
      new(file).call
    end

    def call
      read!
    end

    private

    def read!
      validate_file
      { invites: formatted_rows, errors: @errors }
    end

    def validate_file
      file?

      validate_extension if @errors.nil?
      validate_rows if @errors.nil?
      validate_date_sequence if @errors.nil?
    end

    def formatted_rows
      if @errors.nil?
        @formatted_rows ||= data_file_splited.map do |row|
          ::Invites::FormattedRow.new(row)
        end.sort
      end
    end

    def file?
      @errors ||= { errors: 'File is required' } if file.nil? || read_file.blank?
    end

    def validate_extension
      unless EXTENSIONS_ALLOWS.include?(file_name.split('.').last)
        @errors ||= { errors: 'Extension not allow' }
      end
    end

    def validate_rows
      data_file_splited.each.with_index do |row, index|
        row.strip!
        validate_keywords(row, index)
        validate_inviters(row, index)
      end
    end

    def validate_date_sequence
      return if sequence_time_ordered?

      @errors ||= { date: 'Dates are in not correct order' }
    end

    # helpers

    def data_file_splited
      @data_file_splited ||= @data_file.split("\n")
    end

    def validate_keywords(row, index)
      return if validate_row(row)

      add_action_error(index)
    end

    def validate_row(row)
      KEYWORDS.select do |keyword|
        row.downcase.include?(keyword)
      end.any?
    end

    def validate_inviters(row, index)
      validate_recommends(row, index)
      validate_accepts(row, index)
    end

    def validate_recommends(row, index)
      return unless row.include?('recommends')
      return if inviter_found?(row)

      add_action_error(index)
    end

    def validate_accepts(row, index)
      return unless row.include?('accepts')
      return if no_inviter?(row)

      add_action_error(index)
    end

    def inviter_found?(row)
      action_index = row.index('recommends')
      row[action_index..-1].delete('recommends').gsub(/\s+/, '').present?
    end

    def no_inviter?(row)
      action_index = row.index('accepts')
      row[action_index..-1].delete('accepts').gsub(/\s+/, '').blank?
    end

    def add_action_error(index)
      @errors ||= { action: "Invitation is invalid at #{index} line" }
      raise "Invitation is invalid at #{index} line"
    end

    def sequence_time_ordered?
      dates_sequence.map.with_index do |date, index|
        date <=> dates_sequence[index + 1]
      end.uniq.first.negative?
    end

    def dates_sequence
      data_file_splited.map do |row|
        row.strip!
        date_parse(row)
      end
    end

    def date_parse(row)
      strtime = row.strip.first(DATE_FORMAT_LENGTH)
      Time.zone.parse(strtime)
    end

    def read_file
      @data_file = file.read
    end

    def file_name
      @file_name ||= file.original_filename
    end
  end
end
