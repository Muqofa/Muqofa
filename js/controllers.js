angular.module('starter.controllers', [])

  .controller('AppCtrl', function ($scope, $ionicModal, $timeout, Commons,$state) {
    
    // With the new view caching in Ionic, Controllers are only called
    // when they are recreated or on app start, instead of every page change.
    // To listen for when this page is active (for example, to refresh data),
    // listen for the $ionicView.enter event:
    $scope.ApplicationName = 'Production Application Support';
    $scope.menulogin = false;
    $scope.$on('$ionicView.enter', function(e) {
      $scope.Username = Commons.getUser().username;
      if($scope.Username==''){
        $scope.menulogin = false;
      }else{
        $scope.menulogin = true;
      }
    });

    $scope.logout= function(){
      Commons.setUser({username:'',token:''});
      $scope.Username = '';
      $scope.menulogin = false;
      //alert(Commons.getUser().username);
      $state.go('app.login', {}, {
        reload: true,
        location: 'replace',
        inherit:true
      });
    };
    /*
      // Form data for the login modal
      $scope.loginData = {};

      // Create the login modal that we will use later
      $ionicModal.fromTemplateUrl('templates/login.html', {
        scope: $scope
      }).then(function (modal) {
        $scope.modal = modal;
      });

      // Triggered in the login modal to close it
      $scope.closeLogin = function () {
        $scope.modal.hide();
      };

      // Open the login modal
      $scope.login = function () {
        $scope.modal.show();
      };

      // Perform the login action when the user submits the login form
      $scope.doLogin = function () {
        //alert('');
        //console.log('Doing login', $scope.loginData);


        Commons.setUser($scope.loginData.username);
        alert($scope.loginData.username);
        // Simulate a login delay. Remove this and replace with your login
        // code if using a login system
        $timeout(function () {
          $scope.closeLogin();
        }, 1000);
      };
    */
  })

  .controller('UpdateremainCtrl', function ($scope, $http,$state,Commons,$ionicHistory) {
    $ionicHistory.nextViewOptions({
      disableBack: true
    });

    $scope.$on('$ionicView.enter', function(){
      //alert(Commons.getUser().username);
      // Anything you can think of
      if (Commons.getUser().username=='') {
        $state.go('app.denied', {}, {
          reload: true,
          location: 'replace',
          inherit:true
        });
      }
    });

    $scope.table = [
      {th:'Changed Date', td:'InsertDate'},
      {th:'User Name', td:'UserName'},
      {th:'Cart Number', td:'CARTNUMBER'},
      {th:'Part Number', td:'PARTNUMBER'},
      {th:'Material ID', td:'MATERIALID'},
      {th:'User Size', td:'USERSIZE'},
      {th:'Using MC', td:'USINGMACHINE'},
      {th:'Remain From', td:'REMAINFROM'},
      {th:'Remain To', td:'REMAINTO'}
    ];
    $scope.maximumremaininputs = {
       51:{text:'TREAD',val:100}
      ,52:{text:'SIDE',val:100}
      ,53:{text:'FILLER',val:100}
      ,61:{text:'PLY',val:100}
      ,62:{text:'BUC/2ND BF',val:100}
      ,63:{text:'FLIPPER',val:100}
      ,64:{text:'CHAFER',val:100}
      ,65:{text:'BELT',val:100}
      ,66:{text:'OHABA LAY',val:100}
      ,67:{text:'SP LAYER',val:100}
      ,69:{text:'IN/CH DOUB',val:100}
      ,70:{text:'INNERLINER',val:10}
      ,71:{text:'END GUM',val:100}
      ,72:{text:'END GUM SL',val:100}
      ,81:{text:'BEAD',val:100}
      ,85:{text:'BEAD/BF',val:100}
      ,B1:{text:'TEX TREAT',val:100}
      ,B2:{text:'SR TREAT',val:100}
      ,C1:{text:'OHABA CHA',val:100}      
    };
    $scope.material = [];
    $scope.editremain = {};
    $scope.editremain.num = 0;
    $scope.minRemain = 0;
    $scope.maxRemain = 0;
    $scope.maxRemainMatID = 0;
    $scope.getDt = function (id) {
      $scope.material = [];
      $scope.editremain.num = 0;
      $scope.maxRemain = 0;
      $scope.materialchangelog = [];
      
      if (id.length<10){
        return
      }
      //alert(Commons.getUser().token);
      $http.get(Commons.getDefaultWebApi()+'BSINKBOSS/GetMaterialInventory', {
        params: {
          cartnumber: id
        },
        headers: {
          'Content-Type': 'application/json',
          Authorization: 'Bearer ' + Commons.getUser().token
        }
      }).then(function (response) {
        
        if (response.data.length == 0) {          
        } else {
          if(angular.isUndefined(response.data.tbl[0])){
            
          }else{
            $scope.material = response.data.tbl[0];
            $scope.editremain.num = $scope.material.REMAIN;
            $scope.maxRemain = $scope.material.ACTUAL;
            $scope.maxRemainMatID = $scope.maximumremaininputs[$scope.material.MATERIALID].val;
            if ($scope.maxRemainMatID < $scope.maxRemain){
              $scope.maxRemain =$scope.maxRemainMatID;
            }
            //alert($scope.maxRemainMatID + ' - ' + $scope.maxRemain);
            //goto editremain

          }
          
          $scope.getDtMaterialInventoryLogCartNumber(id);
        }
      });
    }
    $scope.isLoading=false;
    $scope.materialchangelog = [];
    $scope.canupdate=true;
    $scope.maxupdatefreq = 1;
    $scope.getDtMaterialInventoryLogCartNumber = function (id) {
      var cartnumberstr = id.substring(0, 10);
      $scope.materialchangelog = [];
      $scope.canupdate=false;
      //alert(cartnumberstr);
      $scope.isLoading=true;
      $http.get(Commons.getDefaultWebApi()+'BSINKBOSS/GetMaterialInventoryChangeLog', {
        params: {
          cartnumber: cartnumberstr
        },
        headers: {
          'Content-Type': 'application/json',
          Authorization: 'Bearer ' + Commons.getUser().token
        }
      }).then(function (response) {
        if (response.data.length == 0) {
          $scope.materialchangelog = [];
        } else {
          $scope.materialchangelog = response.data.tbl;
          $scope.canupdate=true;
          if($scope.materialchangelog.length >= $scope.maxupdatefreq){
            $scope.canupdate=false;
          }
        }
        $scope.isLoading=false;
      });
    }

    //$scope.getDt('5D0119I361');

    $scope.updateDt = function () {
      //alert($scope.editremain.num);
      if($scope.canupdate == false){
        alert('Sorry, cannot update more than one ');
        return;
      }
      var editremainnum = $scope.editremain.num;
      if(angular.isUndefined($scope.editremain.num)){
        alert('Sorry, cannot update more than maximum value');
        return;
      }

      //alert('Saving data');

      var dt = $scope.material;

      $http.get(Commons.getDefaultWebApi()+'BSINKBOSS/SetMaterialInventory', {
        params: {
          cartnumber: dt.CARTNUMBER,
          remainTo:  $scope.editremain.num,
          keyID:'1',
          username:Commons.getUser().username
        },
        headers: {
          'Content-Type': 'application/json',
          Authorization: 'Bearer ' + Commons.getUser().token
        }
      }).then(function (response) {
        $scope.getDtMaterialInventoryLogCartNumber(dt.CARTNUMBER);
        if (response.data.length == 0) {
          //$scope.material = [];
        } else {
          //
        }
      });
    }

    $scope.getStatusCart = function(id){

      if(id==0){
        return 'Not Use'
      }
      if(id==1){
        return 'Using'
      }
      if(id==2){
        return 'Used'
      }
      if(id==3){
        return 'Hold'
      }

      return ''
    }

  })

  .controller('LogCtrl', function ($scope, $stateParams, $ionicHistory, Commons,$http, ionicDatePicker, $timeout, Excel) {
    $ionicHistory.nextViewOptions({
      disableBack: true
    });

    $scope.table = [{th:'Changed Date', td:'InsertDate'},
                    {th:'User Name', td:'UserName'},
                    {th:'Cart Number', td:'CARTNUMBER'},
                    {th:'Part Number', td:'PARTNUMBER'},
                    {th:'Material ID', td:'MATERIALID'},
                    {th:'User Size', td:'USERSIZE'},
                    {th:'Using MC', td:'USINGMACHINE'},
                    {th:'Remain From', td:'REMAINFROM'},
                    {th:'Remain To', td:'REMAINTO'}];
    $scope.user = Commons.getUser();
    $scope.tgl1 = '';
    $scope.tgl2 = '';
    $scope.getDtMaterialInventoryLogCartNumber = function () {
      $scope.isLoading=true;
      $http.get(Commons.getDefaultWebApi()+'BSINKBOSS/GetMaterialInventoryChangeLogTgl', {
        params: {
          tgl1: $scope.tgl1,
          tgl2: $scope.tgl2
        },
        headers: {
          'Content-Type': 'application/json',
          Authorization: 'Bearer ' + Commons.getUser().token
        }
      }).then(function (response) {
        if (response.data.length == 0) {
          $scope.materialchangelog = [];
        } else {
          $scope.materialchangelog = response.data.tbl;
        }
        $scope.isLoading=false;
      });
    }
    $scope.getDtMaterialInventoryLogCartNumber();

    $scope.openDatePickerOne = function (val) {
      var ipObj1 = {
        callback: function (val) {  //Mandatory
          console.log('Return value from the datepicker popup is : ' + val, new Date(val));
          $scope.tgl1 = new Date(val);
          var tgl1 = new Date(val);
          tgl1.setDate(tgl1.getDate() + 1);
          $scope.tgl2 = tgl1;
          $scope.getDtMaterialInventoryLogCartNumber();
        },
        disabledDates: [
          new Date(2016, 2, 16),
          new Date(2015, 3, 16)
        ],
        from: new Date(2012, 1, 1),
        to: new Date(2100, 1, 1),
        inputDate: new Date(),
        mondayFirst: true,
        disableWeekdays: [],
        closeOnSelect: false,
        templateType: 'popup'
      };
      ionicDatePicker.openDatePicker(ipObj1);
    };
    //export excel
    $scope.exportToExcel=function(tableId){ // ex: '#my-table'
      var exportHref=Excel.tableToExcel(tableId,'sheet1');
      $timeout(function(){location.href=exportHref;},100); // trigger download
    }
  })

  .controller('DeniedCtrl', function ($scope, $stateParams, $state,$ionicHistory) {
    $ionicHistory.nextViewOptions({
      disableBack: true
    });

    $scope.gotologin=function(){
      $state.go('app.login', {}, {
        reload: true,
        location: 'replace',
        inherit:true
      });
    }
  })


  .controller('LoginCtrl', function ($scope, $stateParams, $ionicHistory, $state, $window, $location, Commons, $http) {
    $ionicHistory.nextViewOptions({
      disableBack: true
    });

    $scope.loginData = {};
    Commons.setUser('');

    $scope.login = function () {
      $scope.isLoading=true;
      $http.get(Commons.getDefaultWebApi()+'Common/LoginApp', {
        params: {
          Username: $scope.loginData.username,
          Password: $scope.loginData.password,
          AppID: 59
        },
        headers: {
          'Content-Type': 'application/json',
          Authorization: 'Bearer ' + '123'
        }
      }).then(function (response) {
        if (response.data.length == 0) {
          //alert(response.data);
        } else {
          //alert(response.data);
          if(response.data.Access==true){
            var dtuser = {username:$scope.loginData.username,token:response.data.Token};
            Commons.setUser(dtuser);
            // + response.data.AppName[0].ApplicationName
            alert('Login success ');
            $state.go('app.home', {}, {
              reload: true,
              location: 'replace',
              inherit:true
            });
          }

        }
        $scope.isLoading=false;
      });
    }
    $scope.login();

    $scope.doLogin = function () {
      //alert('');
      //console.log('Doing login', $scope.loginData);
      //http://172.30.8.13/bs/Account/_Login
      var data = {
        Username: $scope.loginData.username,
        Password: $scope.loginData.password
      };
      $scope.login();
      /*
      $http.post('http://172.30.8.13/WebApriTrial/User/Login', JSON.stringify(data)).then(function (response) {

        if (response.data)

        $scope.msg = "Post Data Submitted Successfully!";
        alert($scope.loginData.username);

        }, function (response) {

        $scope.msg = "Service not Exists";

        $scope.headers = response.headers();

        });
      */
      /*
      $http({
        url: 'http://172.30.8.13/WebApriTrial/User/Login',
        method: "POST",
        data: param({
          Username: $scope.loginData.username,
          Password: $scope.loginData.password,
          RememberMe: true
        })
      }).then(function (response) {
        if (response.data.length == 0) {
          $scope.material = [];
        } else {
          $scope.material = response.data.tbl[0];
        }
      });
      */
    /*
      Commons.setUser($scope.loginData.username);
      alert($scope.loginData.username);
      //goto stockcheck
      //$state.go('app.stockcheck', {});
      $state.go('app.updateremain', {}, {
        reload: true,
        location: 'replace',
        inherit:true
      });
    */
      //$window.open('./#/app/updateremain', '_self');
      //$location.url('./#/app/stockcheck');
    };
  })

  .controller('HomeCtrl', function ($scope, $stateParams, $ionicHistory, $state,$ionicModal, Commons) {
    $ionicHistory.nextViewOptions({
      disableBack: true
    });

    //----
    $scope.labels = ["January", "February", "March", "April", "May", "June", "July"];
  $scope.series = ['Series A', 'Series B'];
  $scope.data = [
    [65, 59, 80, 81, 56, 55, 40],
    [28, 48, 40, 19, 86, 27, 90]
  ];
  $scope.onClick = function (points, evt) {
    console.log(points, evt);
  };
  $scope.datasetOverride = [{ yAxisID: 'y-axis-1' }, { yAxisID: 'y-axis-2' }];
  $scope.options = {
    scales: {
      yAxes: [
        {
          id: 'y-axis-1',
          type: 'linear',
          display: true,
          position: 'left'
        },
        {
          id: 'y-axis-2',
          type: 'linear',
          display: true,
          position: 'right'
        }
      ]
    }
  };
  //----
  })
  .controller('TabunganCtrl', function ($scope, $stateParams, $ionicHistory, Commons,$http, ionicDatePicker, $timeout, Excel) {
    $ionicHistory.nextViewOptions({
      disableBack: true
    });

    $scope.table = [{th:'Nama', td:'Nama'},
                    {th:'Tabungan1', td:'Tour'},
                    {th:'Tabungan2', td:'Tabungan'},
                    {th:'Tabungan3', td:'DanSos'},
                    {th:'Total', td:'Total'}];
    $scope.user = Commons.getUser();
    $scope.tgl1 = '';
    $scope.tgl2 = '';
    $scope.getDtMaterialInventoryLogCartNumber = function () {
      $scope.isLoading=true;
      $http.get(Commons.getDefaultWebApi()+'BSINKBOSS/GetMaterialInventoryChangeLogTgl', {
        params: {
          tgl1: $scope.tgl1,
          tgl2: $scope.tgl2
        },
        headers: {
          'Content-Type': 'application/json',
          Authorization: 'Bearer ' + Commons.getUser().token
        }
      }).then(function (response) {
        if (response.data.length == 0) {
          $scope.materialchangelog = [];
        } else {
          $scope.materialchangelog = response.data.tbl;
        }
        $scope.isLoading=false;
      });
    }
    $scope.getDtMaterialInventoryLogCartNumber();

    $scope.openDatePickerOne = function (val) {
      var ipObj1 = {
        callback: function (val) {  //Mandatory
          console.log('Return value from the datepicker popup is : ' + val, new Date(val));
          $scope.tgl1 = new Date(val);
          var tgl1 = new Date(val);
          tgl1.setDate(tgl1.getDate() + 1);
          $scope.tgl2 = tgl1;
          $scope.getDtMaterialInventoryLogCartNumber();
        },
        disabledDates: [
          new Date(2016, 2, 16),
          new Date(2015, 3, 16)
        ],
        from: new Date(2012, 1, 1),
        to: new Date(2100, 1, 1),
        inputDate: new Date(),
        mondayFirst: true,
        disableWeekdays: [],
        closeOnSelect: false,
        templateType: 'popup'
      };
      ionicDatePicker.openDatePicker(ipObj1);
    };
    //export excel
    $scope.exportToExcel=function(tableId){ // ex: '#my-table'
      var exportHref=Excel.tableToExcel(tableId,'sheet1');
      $timeout(function(){location.href=exportHref;},100); // trigger download
    }

  });