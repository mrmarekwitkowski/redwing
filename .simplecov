SimpleCov.start do
  enable_coverage :branch
  coverage_dir 'tmp/coverage'
  add_filter '/spec/'
end
