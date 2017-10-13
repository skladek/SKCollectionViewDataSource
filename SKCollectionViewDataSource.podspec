Pod::Spec.new do |spec|
  spec.name = 'SKCollectionViewDataSource'
  spec.version = '2.0.0'
  spec.license = 'MIT'
  spec.summary = 'An easy to configure data source for UICollectionView.'
  spec.homepage = 'https://github.com/skladek/SKCollectionViewDataSource'
  spec.authors = { 'Sean Kladek' => 'skladek@gmail.com' }
  spec.source = { :git => 'https://github.com/skladek/SKCollectionViewDataSource.git', :tag => spec.version }
  spec.ios.deployment_target = '9.0'
  spec.source_files = 'Source/*.swift'
end
