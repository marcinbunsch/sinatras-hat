require File.join(File.dirname(__FILE__), 'spec_helper')

describe "sinatra's hat" do
  attr_reader :response
  
  describe "default behavior" do
    it "should work as usual" do
      get_it '/'
      response.should be_ok
    end

    it "should work properly" do
      get_it '/hello/world'
      body.should == 'Hello world!'
    end
  end
  
  describe "customizing options" do
    it "should allow for custom finder" do
      mock(result = []).to_json
      mock(Bar).find(:all).returns(result)
      get_it '/bars.json'
      response.should be_ok
    end
  end
  
  describe "generating routes for model" do
    describe "index" do
      it "should generate index for foos for json" do
        mock(result = []).to_json
        mock(Foo).all.returns(result)
        get_it '/foos.json'
        response.should be_ok
      end

      it "should generate index for foos for xml" do
        mock(result = []).to_xml
        mock(Foo).all.returns(result)
        get_it '/foos.xml'
        response.should be_ok
      end
      
      it "should return 400 when format omitted" do
        get_it '/foos'
        response.status.should == 400
      end
      
      it "should return 406 when format unknown" do
        get_it '/foos.bars'
        response.status.should == 406
      end
    end

    describe "show" do
      it "should generate show route for json" do
        mock(result = Object.new).to_json
        mock(Foo).find.with('3').returns(result)
        get_it '/foos/3.json'
        response.should be_ok
      end
      
      it "should generate show route for xml" do
        mock(result = Object.new).to_xml
        mock(Foo).find.with('3').returns(result)
        get_it '/foos/3.xml'
        response.should be_ok
      end
    end
    
    describe "update" do
      it "should update a record via json" do
        mock(result = Object.new).attributes = { "name" => "Frank" }
        mock(result).to_json
        mock(result).save
        mock(Foo).find.with('3').returns(result)
        put_it '/foos/3.json', "foo" => { "name" => "Frank" }.to_json
        response.should be_ok
      end
      
      it "should update a record via xml" do
        mock(result = Object.new).attributes = { "name" => "Frank" }
        mock(result).to_xml
        mock(result).save
        mock(Foo).find.with('3').returns(result)
        put_it '/foos/3.xml', "foo" => <<-XML
        <?xml version="1.0" encoding="UTF-8"?>
        <hash>
          <name>Frank</name>
        </hash>
        XML
        response.should be_ok
      end
    end
  end
end