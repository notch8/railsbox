require 'rails_helper'

describe TemplateConfiguration do
  describe '#save' do
    let(:dir) { Dir.mktmpdir }
    let(:configuration) do
      { vm_name: 'myapp',
        vm_os: 'ubuntu/trusty64',
        vm_memory: 700,
        vm_cores: 2,
        vm_forwarded_port: 8080,
        server_name: 'localhost',
        ruby_version: '2.1.2',
        database_name: 'myapp',
        database_user: 'myapp' }
    end

    describe 'files' do
      subject(:output) { IO.read(File.join(dir, file)) }

      before { described_class.new(configuration).save(dir) }

      context 'ansible/group_vars/all.yml' do
        let(:file) { self.class.description }

        it 'sets server_name' do
          expect(output).to include %Q(server_name: localhost)
        end
      end

      context 'Vagrantfile' do
        let(:file) { self.class.description }

        it 'sets name' do
          expect(output).to include %Q(config.vm.define 'myapp')
          expect(output).to include %Q(hostname = 'myapp')
        end

        it 'sets operating system' do
          expect(output).to include %Q(config.vm.box = 'ubuntu/trusty64')
        end

        it 'sets memory' do
          expect(output).to include %Q(.memory = 700)
        end

        it 'sets cores' do
          expect(output).to include %Q(.cpus = 2)
        end

        it 'sets forwarded port' do
          expect(output).to include %Q(vm.network 'forwarded_port', guest: 80, host: 8080)
        end
      end

      after { FileUtils.remove_entry_secure dir }
    end
  end
end