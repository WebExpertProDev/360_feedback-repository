source 'https://rubygems.org'

ruby "2.6.3"
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end
gem 'rails', '~> 5.2', '>= 5.2.3'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.12'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'sqlite3'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem "meta_request" # browser extension for rails metrics
  gem 'bullet' # for N+1 queries
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'mimemagic', github: 'mimemagicrb/mimemagic', ref: '01f92d86d15d85cfd0f20dabd025dcbd36a8a60f'
gem 'devise', github: 'heartcombo/devise', branch: 'ca-omniauth-2'
gem "awesome_print", require:"ap" #for rails console 
#gem 'devise'
gem 'jquery-rails'
gem 'omniauth-facebook'
gem 'omniauth-linkedin-oauth2'
gem 'omniauth-google-oauth2'
gem 'omniauth-twitter'
gem 'cancancan', '~> 2.0'
gem 'friendly_id', '~> 5.2', '>= 5.2.4'
gem "paperclip"
gem 'sweetalert-rails'

gem 'money-rails', '~>1.12' # For money/balance objects
gem 'stripe'
gem 'ultrahook'
gem "figaro"
gem 'toastr_rails'

gem 'kaminari'

gem 'devise_invitable'
gem 'letter_opener'


gem "chartkick"
gem 'chartjs-ror'
gem 'fusioncharts-rails'

gem 'roo'
gem 'interactor'
gem 'mailgun-ruby'
gem 'globalize', git: 'https://github.com/globalize/globalize'
gem 'activemodel-serializers-xml'