namespace :linked_files do
  namespace :upload do

    task :files => ["deploy:check:make_linked_dirs", :concat_linked_config_files] do
      on roles :all do
        fetch(:old_linked_files, []).each do |file|
          upload! File.join("upload", file), File.join(shared_path, file)
        end
        fetch(:config_files,[]).each do |file|
          upload! File.join("upload", fetch(:stage).to_s, file), File.join(shared_path, file)
        end
      end
    end
  end

  task :concat_linked_config_files do
    on roles :all do
      Capistrano::LinkedFiles.synchronize do
        unless fetch(:old_linked_files, false)
          set :old_linked_files, fetch(:linked_files,[])
          set :linked_files, (fetch(:config_files,[]) + (fetch(:linked_files,[]))).uniq
        end
      end
    end
  end

  desc "Upload stage-separated config files, and link them."
  task :upload do
    invoke "linked_files:upload:files"
  end

end

before "deploy:symlink:shared", "linked_files:concat_linked_config_files"

