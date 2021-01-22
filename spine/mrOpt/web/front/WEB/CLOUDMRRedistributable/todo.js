.directive('cmFileManager',[function() {
    return {
        restrict: 'E',
        scope: {
            list:'=',
            model:'=',
            uploadfunction:'='
        },  
                templateUrl: 'cmFilemanager_canc.html',
//        template: '<span class="cmlabel">{{sOpt}}: {{sValue}}</span>',
        link: function(scope, element, attrs) {

           


        }
    }

}])


<div style="display:  inline">
  
    
  <div style = "display: inline-block;margin-right: 0.5em">
    <button class="btn cmButton" ng-click="uploadfunction(data.f.myFile)"  >   <i class="fas fa-folder-open " style="vertical-align:middle"></i> </button>
    </div>
    <span style="display: inline-block;margin-right: 0.5em;">OR</span>
    
    <div style = "display: inline-block;margin-right: 0.5em" ng-show="list.length>0">
    <cm-datalist-json list="list" model="model" label="<i class='fas fa-database fa-2x'></i>" fieldsshow="name" optionsvaluesfield="ID" ></cm-datalist-json>
    </div>
    
</div>
