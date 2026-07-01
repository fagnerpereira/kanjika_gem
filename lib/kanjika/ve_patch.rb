# frozen_string_literal: true

require "ve"

class Ve
  class Provider
    class MecabIpadic < Ve::Provider
      # Override parse to handle when MeCab splits the stop marker (VeEnd)
      def parse(text, options = {})
        start! if @stdin.nil?
        return Ve::Parse::MecabIpadic.new(text, []) if @stdin.nil? || @stdout.nil?

        # We rescue stdin writing to handle if the process is closed or broken
        begin
          @stdin.puts "#{text} #{BIT_STOP}"
        rescue
          return Ve::Parse::MecabIpadic.new(text, [])
        end

        output = []

        # Read lines until we hit EOS
        begin
          while (line = @stdout.readline.force_encoding("UTF-8"))
            output << line
            break if line.strip == "EOS"
          end
        rescue
          # If reading fails, just proceed with what we have
        end

        # Clean up output by finding the BIT_STOP tokens at the end before EOS
        lines_to_check = output[0...-1] # exclude EOS
        (1..5).each do |n|
          next if lines_to_check.length < n
          candidate_lines = lines_to_check[-n..]
          literals = candidate_lines.map { |l| l.split("\t").first }
          if literals.join == BIT_STOP
            output.slice!(output.length - 1 - n, n)
            break
          end
        end

        Ve::Parse::MecabIpadic.new(text, output)
      end
    end
  end
end
