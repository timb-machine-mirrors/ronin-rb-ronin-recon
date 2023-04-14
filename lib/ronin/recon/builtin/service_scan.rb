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

require 'ronin/recon/worker'

require 'ronin/nmap'

module Ronin
  module Recon
    #
    # A recon worker that performs an nmap service scan.
    #
    class ServiceScan < Worker

      register 'service_scan'

      accepts IP

      summary 'Scans an IP for services'

      description <<~DESC
        Performs an nmap service scan of the given IP and retruns the open
        ports and discovered services.
      DESC

      param :ports, String, desc: 'Optional port list to scan'

      #
      # Performs an nmap service scan on the given IP value.
      #
      # @param [Values::IP] ip
      #   The given IP to scan.
      #
      # @yield [new_value]
      #   The discovered open ports will be yielded.
      #
      # @yieldparam [Values::OpenPort, Values::Nameserver, Values::Website] new_value
      #   A discovered open port on the IP address, discovered nameserver, or
      #   website.
      #
      def process(ip)
        xml = Nmap.scan(ip.address, verbose:      true,
                                    service_scan: true,
                                    ports:        params[:ports])

        xml.host.open_ports.each do |open_port|
          number   = open_port.number
          protocol = open_port.protocol

          yield OpenPort.new(ip,number, protocol: protocol)

          if (service = open_port.service)
            host = xml.host.to_s

            case service.name
            when 'domain' then yield Nameserver.new(host)
            when 'https'  then yield Website.https(host,number)
            when 'http'   then yield Website.http(host,number)
            end
          end
        end
      end

    end
  end
end