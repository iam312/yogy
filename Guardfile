guard 'ctags-bundler', :binary => '/usr/local/bin/ctags', :src_path => ["app", "lib", "spec/support"], :arguments => '-R --languages=ruby --fields=+l --exclude=.git --exclude=gems.tags --exclude=tags --exclude=log --exclude=logs --exclude=doc $(bundle list --paths) `echo $GEM_ROOT`' do
  watch(/^(app|lib|spec\/support)\/.*\.rb$/)
  watch('Gemfile.lock')
end
