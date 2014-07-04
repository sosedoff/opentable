require 'fileutils'
require 'net/ftp'

module OpenTable
  class Downloader
    REGEX_NEW = /(Affiliates - New Online Restaurant [\d]{1,}\.[\d]{1,}\.[\d]{1,} - [\d]{1,}\.[\d]{1,}\.[\d]{1,}.xls)/i
    REGEX_ALL = /OpenTable Restaurant List/i

    attr_reader :host, :user, :password

    # Initialize a new downloader instance
    # @param options [Hash] downloader options
    def initialize(options={})
      @host     = options[:host]     || ENV['OT_HOST']
      @user     = options[:user]     || ENV['OT_USER']
      @password = options[:password] || ENV['OT_PASSWORD']
    end

    # Download data snapshot to the target directory
    # @param path [String] download path
    # @param overwrite [Boolean] overwrite flag
    def download_to(path, overwrite=false)
      path = File.expand_path(path)

      if File.exists?(path)
        if overwrite
          FileUtils.rm(path)
        else
          return true
        end
      end

      puts "Establishing FTP connection to #{host}"

      Net::FTP.open(host) do |ftp|
        puts "Connected. Authenticating with #{user}:#{password}"

        ftp.login(user, password)
        files = ftp.list

        puts "Downloading file..."
        files.each do |f|
          if f =~ REGEX_ALL
            ftp.getbinaryfile("#{$1}", path)
          end
        end

        ftp.close
      end

      File.exists?(path)
    end
  end
end