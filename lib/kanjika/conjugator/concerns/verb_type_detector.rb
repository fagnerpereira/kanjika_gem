module Kanjika
  module Conjugator
    module Concerns
      module VerbTypeDetector
        private

        def determine_verb_type(token)
          return :ichidan if ichidan?(token)
          return :godan if godan?(token)
          :irregular if irregular?(token)
        end

        def ichidan?(token)
          token[:inflection_type].split("・").include?(Base::ICHIDAN)
        end

        def godan?(token)
          token[:inflection_type].split("・").include?(Base::GODAN)
        end

        def irregular?(token)
          token[:inflection_type].split("・").include?(Base::KURU) ||
            token[:inflection_type].split("・").include?(Base::SURU)
        end
      end
    end
  end
end
