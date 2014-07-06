describe('Testing the testing', function() {
  var $scope;
  beforeEach(module('kgapp'));
  $scope = {};
  beforeEach(inject(function($controller) {
    $scope = {};
    return $controller('SplashCtrl', {
      $scope: $scope
    });
  }));
  return it('should return the same text', function() {
    return assert.equal($scope.log('foo'), 'foo');
  });
});
