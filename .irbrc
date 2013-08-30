# Include this in your .irbrc
def unbundled_require(gem, options = {})
  if defined?(::Bundler)
    spec_path = Dir.glob("#{Gem.dir}/specifications/#{gem}-*.gemspec").last
    if spec_path.nil?
      warn "Couldn't find #{gem}"
      return
    end
 
    spec = Gem::Specification.load spec_path
    spec.activate
  end
 
  begin
    require options[:require] || gem
    yield if block_given?
  rescue Exception => err
    warn "Couldn't load #{gem}: #{err}"
  end
end
 
# Then use like this
unbundled_require 'hirb' do
  Hirb.enable
end

unbundled_require 'awesome_print' do
  AwesomePrint.irb!
end