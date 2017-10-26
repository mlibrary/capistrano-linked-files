Capistrano::LinkedFiles = Mutex.new
load File.expand_path('../tasks/linked_files.rake', __FILE__)
