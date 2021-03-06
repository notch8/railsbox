require 'open-uri'

module TestHelpers
  module Box

    class VagrantDriver
      def initialize(dir:, env:)
        @dir = dir
        @env = env
        @destroyed = false
      end

      def up
        run 'up'
      end

      def destroy
        run 'destroy', ['-f']
        @destroyed = true
      end

      def destroyed?
        @destroyed
      end

      private

      def run(command, args=[])
        cmd = "vagrant #{command} #{args.join(' ')}"
        CommandRunner.run(cmd: cmd, dir: @dir)
      end
    end

  end
end
