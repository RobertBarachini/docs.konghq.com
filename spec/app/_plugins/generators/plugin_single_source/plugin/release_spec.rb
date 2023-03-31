RSpec.describe PluginSingleSource::Plugin::Release do
  let(:plugin_name) { 'acme/jwt-signer' }
  let(:is_latest) { true }
  let(:source) { '_index' }
  let(:version) { '2.8.x' }
  let(:plugin) do
    PluginSingleSource::Plugin::Base.make_for(dir: plugin_name, site:)
  end

  subject { described_class.new(site:, version:, plugin:, is_latest:, source:) }

  describe '#configuration_parameters_table' do
    context 'when there is a specific folder for the version' do
      let(:is_latest) { false }
      let(:version) { '2.5.x' }
      let(:source) { '_2.2.x' }

      it 'returns the content of the _configuration.yml inside the corresponding folder' do
        expect(subject.configuration_parameters_table)
          .to eq(SafeYAML.load(File.read(File.expand_path('_hub/acme/jwt-signer/_2.2.x/_configuration.yml', site.source))))
      end
    end

    context 'when using `_index.md`' do
      it 'returns the content of the _configuration.yml at the top level' do
        expect(subject.configuration_parameters_table)
          .to eq(SafeYAML.load(File.read(File.expand_path('_hub/acme/jwt-signer/_configuration.yml', site.source))))
      end
    end
  end

  describe '#frontmatter' do
    let(:frontmatter) do
      SafeYAML.load(
        File.read(File.expand_path(file_path, site.source)).match(/---\n(.*)\n---/m)[1]
      )
    end

    shared_examples_for 'returns the frontmatter section of the file parsed as yaml' do
      it { expect(subject.frontmatter).to eq(frontmatter) }
    end

    context 'when there is a specific folder for the version' do
      let(:is_latest) { false }
      let(:version) { '2.5.x' }
      let(:source) { '_2.2.x' }
      let(:file_path) { '_hub/acme/jwt-signer/_2.2.x/_index.md' }

      it_behaves_like 'returns the frontmatter section of the file parsed as yaml'
    end

    context 'when using `_index.md`' do
      let(:file_path) { '_hub/acme/jwt-signer/_index.md' }
      it_behaves_like 'returns the frontmatter section of the file parsed as yaml'
    end
  end

  describe '#latest?' do
    it { expect(subject.latest?).to eq(is_latest) }
  end

  describe '#generate_pages' do
    context 'when there is a specific folder for the version' do
      let(:is_latest) { false }
      let(:version) { '2.5.x' }
      let(:source) { '_2.2.x' }

      it 'returns the relative path to the _index.md file inside the corresponding folder' do
        expect(subject.generate_pages.map(&:permalink)).to match_array([
          '/hub/acme/jwt-signer/2.5.x.html',
          '/hub/acme/jwt-signer/2.5.x/changelog.html',
          '/hub/acme/jwt-signer/2.5.x/how-to.html',
          '/hub/acme/jwt-signer/2.5.x/reference.html'
        ])
      end
    end

    context 'when using `_index.md`' do
      it 'returns the relative path to the top-level _index.md file' do
        expect(subject.generate_pages.map(&:permalink)).to match_array([
          '/hub/acme/jwt-signer/',
          '/hub/acme/jwt-signer/changelog/',
          '/hub/acme/jwt-signer/how-to/',
          '/hub/acme/jwt-signer/how-to/nested/tutorial/',
          '/hub/acme/jwt-signer/reference/',
          '/hub/acme/jwt-signer/reference/api/',
        ])
      end
    end
  end

  describe 'Validations' do
    context 'when the `source` does not start with `_`' do
      let(:source) { 'index' }
      let(:version) { '3.0.x' }
      let(:is_latest) { true }

      it 'raises an expection' do
        expect { subject }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#example' do
    context 'when there is an example for the specific version' do
      let(:is_latest) { false }
      let(:version) { '2.5.x' }
      let(:source) { '_2.2.x' }

      it 'loads the corresponding example file' do
        expect(subject.example)
          .to eq(SafeYAML.load(File.read(File.expand_path('_hub/acme/jwt-signer/examples/_2.2.x.yml', site.source))))
      end
    end

    context 'when there is not a specific example ' do
      let(:source) { '_index' }
      let(:version) { '3.0.x' }
      let(:is_latest) { true }

      it 'loads the _index.yaml example file' do
        expect(subject.example)
          .to eq(SafeYAML.load(File.read(File.expand_path('_hub/acme/jwt-signer/examples/_index.yml', site.source))))
      end
    end
  end
end