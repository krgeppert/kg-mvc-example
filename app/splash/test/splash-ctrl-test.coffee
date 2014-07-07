describe 'Testing the testing', () ->

  beforeEach module('kgapp')

  $scope = {}


  beforeEach inject ($controller) ->
    $scope = {}
    $controller 'SplashCtrl',
      $scope: $scope

  it 'should return the same text', ()->
    assert.equal $scope.log('foo'), 'foo'



