# frozen_string_literal: true

module Redwing
  module Error
    class Base < StandardError; end

    class UnknownCommand < Base; end
    class PerformNotImplemented < Base; end
    class InvalidResponse < Base; end
  end
end
