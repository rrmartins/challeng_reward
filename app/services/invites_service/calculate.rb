module InvitesService
  class Calculate
    attr_accessor :file, :errors

    def initialize(file)
      @file = file
    end

    def self.call(file)
      new(file).call
    end

    def call
      calculate!
    end

    private

    def calculate!
      {
        calculated: calculator,
        errors: set_errors
      }
    end

    def calculator
      InvitesService::Calculator.call(read_file[:invites]) if read_file[:errors].nil?
    end

    def read_file
      @read_file ||= InvitesService::ReadFile.call(file)
    end

    def set_errors
      @errors = read_file[:errors]
    end
  end
end
