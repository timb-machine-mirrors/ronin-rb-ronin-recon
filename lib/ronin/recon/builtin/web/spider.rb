# frozen_string_literal: true
#
# ronin-recon - A micro-framework and tool for performing reconnaissance.
#
# Copyright (c) 2023 Hal Brodigan (postmodern.mod3@gmail.com)
#
# ronin-recon is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-recon is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with ronin-recon.  If not, see <https://www.gnu.org/licenses/>.
#

require 'ronin/recon/web_worker'

require 'ronin/web/spider'

module Ronin
  module Recon
    module Web
      #
      # A recon worker that spiders a website.
      #
      class Spider < WebWorker

        register 'web/spider'

        accepts Website

        summary 'Spiders a website'

        description <<~DESC
          Spiders a website and returns every URL.
        DESC

        #
        # Spiders a website and yields every spidered URL.
        #
        # @param [Values::Website] website
        #   The website value to start spidering.
        #
        # @yield [url]
        #   Every spidered URL will be yielded.
        #
        # @yieldparam [Values::URL] url
        #   A URL visited by the spider.
        #
        def process(website)
          Ronin::Web::Spider.site(website.to_uri) do |agent|
            agent.every_page do |page|
              yield URL.new(page.url.to_s)
            end
          end
        end

      end
    end
  end
end