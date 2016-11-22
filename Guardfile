
guard :rspec, cmd: 'rspec spec --tag ~skip --tag ~pending', all_on_start:true do
  watch(%r{^app/(.+)\.rb$})             { 'spec' }
  watch(%r{^models/(.+)\.rb$})          { 'spec' }
  watch(%r{^errors/(.+)\.mustache$})    { 'spec' }
  watch(%r{^config/(.+)$})              { 'spec' }
  
  watch(%r{^spec/(.+)\.rb$})            { 'spec' }
  watch('spec/spec_helper.rb')          { 'spec' }

  watch('config.ru')                    { 'spec' }
  watch('Gemfile.lock')                 { 'spec' }
end
