require 'spec_helper'

require_relative '../../../lib/locomotive/steam/adapters/memory.rb'

describe Locomotive::Steam::ContentTypeFieldRepository do

  let(:collection)  { [{ name: 'title', type: 'string' }, { name: 'body', type: 'text' }] }
  let(:adapter)     { Locomotive::Steam::MemoryAdapter.new(nil) }
  let(:repository)  { described_class.new(adapter) }

  before { allow(adapter).to receive(:collection).and_return(collection) }

  describe '#by_name' do

    let(:name) { nil }

    subject { repository.by_name(name) }

    it { expect(subject).to eq nil }

    context 'with an existing name' do

      let(:name) { 'title' }
      it { expect(subject.type).to eq :string }

    end

  end

  describe '#no_associations' do

    let(:collection) { [{ name: 'title', type: 'string' }, { name: 'author', type: 'belongs_to' }] }

    subject { repository.no_associations }

    it { expect(subject.size).to eq 1 }
    it { expect(subject.size).to eq 1 }

  end

  describe '#unique' do

    let(:collection)  { [{ name: 'name', type: 'string' }, { name: 'email', type: 'email', unique: true }] }

    subject { repository.unique }

    it { expect(subject.keys).to eq ['email'] }

  end

  describe '#default' do

    let(:collection)  { [{ name: 'name', type: 'string' }, { name: 'email', type: 'email', default: 'john@doe.net' }] }

    subject { repository.default }

    it { expect(subject.first.name).to eq 'email' }
    it { expect(subject.count).to eq 1 }

  end

  describe '#files' do

    let(:collection)  { [{ name: 'name', type: 'string' }, { name: 'picture', type: 'file' }] }

    subject { repository.files }

    it { expect(subject.first.name).to eq 'picture' }
    it { expect(subject.count).to eq 1 }

  end

  describe '#dates_and_date_times' do

    let(:collection)  { [{ name: 'name', type: 'string' }, { name: 'launched_at', type: 'date' }, { name: 'updated_at', type: 'date_time' }] }

    subject { repository.dates_and_date_times }

    it { expect(subject.map(&:name)).to eq(['launched_at', 'updated_at']) }

  end

  describe '#localized_names' do

    let(:collection)  { [{ name: 'name', type: 'string', localized: true }, { name: 'picture', type: 'file' }, { name: 'category', type: 'select', localized: true }] }

    subject { repository.localized_names }

    it { expect(subject).to eq(['name', 'category', 'category_id']) }

    context 'without the select field id' do

      subject { repository.localized_names(include_select_field_id: false) }

      it { expect(subject).to eq(['name', 'category']) }

    end

  end

end
