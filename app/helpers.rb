def require_all dir, options={ except:[] }
  # TODO: Test + handle errors:
  # 1. When one file needs another file in same dir. This should reload the failed file at the end.
  # 2. When one file needs another file in another dir. This should raise a different error.
  # 3. When the dependiencies are 2 levels deep.
  failures = []
  
  Dir[ "./#{ dir }/*.rb" ].reject{| f | options[ :except ]
                                          .include?( filename_without_suffix_for f )}
                          .each{ | f | require_one f, failures }

  failures.each{| f | require f }
end

def filename_without_suffix_for file
  File.basename( file ).gsub( '.rb', '' )
end

def require_one file, failures
  begin
    require file
  rescue NameError => e
    failures << file
  end
end

def magenta message
  "\e[35m#{ message }\e[0m"
end

def red message
  "\e[35m#{ message }\e[0m"
end
