require "minitest/autorun"
require_relative "../../../../lib/ruby/toolbox/net/uri"

describe Ruby::Toolbox::Net::Uri do
	subject do
		Ruby::Toolbox::Net::Uri.new('http://example.com/a/b/?a=1&a=2&b=3')
	end

	it '#params_hash returns a hash of parameters {name, value}' do
    	subject.params_hash.must_equal({a: 2, b: 3})
  	end
end
