require 'spec_helper'
require 'fakeweb'

describe RSolr::Connection do
  describe '#get' do
    context 'with valid basic auth credentials' do
      before do
        FakeWeb.register_uri :get,
                             'http://user:pass@127.0.0.1:8983/solr/select?q=a',
                             :body => 'Authorized'
      end

      let(:client) { RSolr::Client.new(RSolr::Connection.new, :url => 'http://user:pass@127.0.0.1:8983/solr') }
      let(:result) { client.get('/select', :params => {:q => 'a'}) }

      specify { result.response[:data].should be_nil }
      specify { result.response[:body].should eq('Authorized') }
      specify { result.response[:status].should eq(200) }
      specify { result.request[:path].should eq('/select') }
      specify { result.request[:uri].to_s.should eq('http://user:pass@127.0.0.1:8983/solr/select?q=a') }
      specify { result.response[:headers].should be_empty }
      specify { result.request[:params].should eq({:q => 'a'}) }
    end

    context 'with invalid basic auth credentials' do
      before do
        FakeWeb.register_uri :get,
                             'http://user:pass@127.0.0.1:8983/solr/select?q=a',
                             :body => 'Unauthorized',
                             :status => [401, 'Unauthorized']
      end

      let(:client) { RSolr::Client.new(RSolr::Connection.new, :url => 'http://user:pass@127.0.0.1:8983/solr') }
      let(:result) { client.get('/select', :params => {:q => 'a'}) }

      specify { result.response[:data].should be_nil }
      specify { result.response[:body].should eq('Unauthorized') }
      specify { result.response[:status].should eq(401) }
      specify { result.request[:path].should eq('/select') }
      specify { result.request[:uri].to_s.should eq('http://user:pass@127.0.0.1:8983/solr/select?q=a') }
      specify { result.response[:headers].should be_empty }
      specify { result.request[:params].should eq({:q => 'a'}) }
    end
  end
  
  describe '#post' do
    context 'with valid basic auth credentials' do
      before do
        FakeWeb.register_uri :post,
                             'http://user:pass@127.0.0.1:8983/solr/update',
                             :body => 'Authorized'
      end

      let(:client) { RSolr::Client.new(RSolr::Connection.new, :url => 'http://user:pass@127.0.0.1:8983/solr') }
      let(:result) { client.post('/update', :data => '<rollback/>') }

      specify { result.request[:data].should eq('<rollback/>') }
      specify { result.response[:body].should eq('Authorized') }
      specify { result.response[:status].should eq(200) }
      specify { result.request[:path].should eq('/update') }
      specify { result.request[:uri].to_s.should eq('http://user:pass@127.0.0.1:8983/solr/update') }
      specify { result.response[:headers].should be_empty }
      specify { result.request[:params].should be_empty }
    end
  
    context 'with invalid basic auth credentials' do
      before do
        FakeWeb.register_uri :post,
                             'http://user:pass@127.0.0.1:8983/solr/update',
                             :body => 'Unauthorized',
                             :status => [401, 'Unauthorized']
      end

      let(:client) { RSolr::Client.new(RSolr::Connection.new, :url => 'http://user:pass@127.0.0.1:8983/solr') }
      let(:result) { client.post('/update', :data => '<rollback/>') }

      specify { result.request[:data].should eq('<rollback/>') }
      specify { result.response[:body].should eq('Unauthorized') }
      specify { result.response[:status].should eq(401) }
      specify { result.request[:path].should eq('/update') }
      specify { result.request[:uri].to_s.should eq('http://user:pass@127.0.0.1:8983/solr/update') }
      specify { result.response[:headers].should be_empty }
      specify { result.request[:params].should be_empty }
    end
  end
end