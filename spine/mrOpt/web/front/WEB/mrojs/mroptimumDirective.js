MROPTIMUM.directive('fileModel', ['$parse', function ($parse) {
    return {
        restrict: 'A',
        link: function(scope, element, attrs) {
            var model, modelSetter;



            attrs.$observe('fileModel', function(fileModel){
                model = $parse(attrs.fileModel);
                modelSetter = model.assign;
            });


            element.bind('change', function(){

                scope.$apply(function(){
                    modelSetter(scope.$parent, element[0].files[0]);
                });
            });
        }
    };
}]);