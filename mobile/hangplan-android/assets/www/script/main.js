var hangplan = {};
(function() {
    //Basic environment properties
    this.view = { 'container' : null };
	this.server = 'http://hangplan.com/';
	this.secureServer = 'https://hangplan.herokuapp.com/';	
	
    //Logged in user object
    this.user = {
    	email : '',
    	token: '',
    	name: '',
    	extend: function(data){
    		this.uid = data.email;
    		this.token = data.token;
    		this.name = data.name;	
    	},
    	clear: function(){
    		this.uid = '';
    		this.tokenBase = '';
    		this.display = '';
    		this.following = [];
    	}   	
    };
        
    this.init = function(containerDiv){
    	hangplan.view.container = $(containerDiv);
		hangplan.view.container.pageTurner({ bindMobileTouchEvents: false });
		
		$(containerDiv).ajaxError(function(xhr, status, settings, err){
			hangplan.handleError(err);
		});
    	
    	if (window.location.hash != '#m'){
	       	document.addEventListener('deviceready', hangplan.deviceReady, false);       
	       	document.addEventListener("backbutton", hangplan.backbutton, false);
	        document.addEventListener("menubutton", hangplan.menubutton, false);
	        FB.init({ appId: "223798634351683", nativeInterface: PG.FB });
      	}else{
        	hangplan.deviceReady();
       }
    };
    
    this.deviceReady = function(){        
        hangplan.login();  
    };
    
    this.login = function(){
    	var ud = window.localStorage.getItem('hangplan-user');
    	if (ud){
    		var userData = JSON.parse(ud);
    		hangplan.user.extend(userData);
    		hangplan.load();
    	}else{
    		hangplan.view.container.pageTurner('reroot', 'loginPage');    		
    		$('#btnLogin').live('click', function(){ 			
				/*FB.login(function(response) {
					if (response.session) {
						var url = hangplan.secureServer + '/user/facebook?key=' + response.session.access_token;
						console.log(url);
						/*hangplan.ajax('GET', hangplan.SecureServer + '', null, function(data){
							//EXTEND USER & save
							//hangplan.handleError(data.mobile_key);	
							//hangplan.load();	
						});
						hangplan.load();
					}
                },
					{ perms: "email" }
                );*/
            	hangplan.load();
    		});
    	}
    }
    
    this.logout = function(){
    	hangplan.user.clear();
    	window.localStorage.removeItem('hangplan-user');
    	window.location.reload();
    }
    
    this.load = function(){
        hangplan.view.container.pageTurner('reroot', 'homePage');        
        hangplan.updateCalendar();
		$('#btnLogout').click(function(){ hangplan.logout(); });
		
		$('.calItem').live('click', function(){
			var id = $(this).attr('data-id');
			console.log(id);
			hangplan.updatePlan(id);
			if (id)hangplan.view.container.pageTurner('navigate', 'detailsPage');  
			
		});
		
		$('#btnin').live('click', function(){
			$(this).replaceWith('<h2 style="text-align: center; color: green;">Hooray!</h2>');
			
		});
	};
	
	this.updatePlan = function(id){
		//determine if/when to do a refresh
		$('#detailPlan').html('');
		
		hangplan.ajax('GET', hangplan.secureServer + "plans/" + id +'.json', null, function(data){
			$('#planTemplate').tmpl(data).appendTo($('#detailPlan'));
		});
	};
	
	this.updateCalendar = function(){
		//determine if/when to do a refresh
		$('#calendarList').html('');
		

		hangplan.ajax('GET', hangplan.secureServer + 'plans.json', null, function(data){

			$('#calItemTemplate').tmpl(data).appendTo($('#calendarList'));
		});
	};
	
	this.backbutton = function(){
		hangplan.view.container.pageTurner('back');
	};
	
	this.menubutton = function(){
		hangplan.view.container.pageTurner('root');
	};
		
	this.working = function(show, message, controls){
		if (show){
			if (message){
				$('#worker div').html(message);
			}else{
				$('#worker div').html('Loading...');
			}
			$('#worker').css('top', $(window).scrollTop() + ($('html').height()/2) - 100);
			$('#worker').css('left', ($(window).width()/2) - 75);
			$('#worker').show();
			if (controls){
				for(var i = 0; i < controls.length; i++)controls[i].hide();
			}	
		}else{
			$('#worker').hide();
			if (controls){
				for(var i = 0; i < controls.length; i++)controls[i].show();
			}	
		}
	}
	
	this.styledDay = function(string){
		var weekdays = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
		var dayName = weekdays[this.fromISO(string).getDay()];
		var months = [ "January", "February", "March", "April", "May", "June", 
		               "July", "August", "September", "October", "November", "December" ];
		var monthName = months[this.fromISO(string).getMonth()];
		return dayName+", "+monthName+" "+this.fromISO(string).getDate();
	}
	

	this.styledTime = function(string) {
		var h = this.fromISO(string).getHours();
		var m = this.fromISO(string).getMinutes();
		if (h > 12) {
			return (h-12-4)+":"+m+" pm";
		} else {
			return (h-4)+":"+m+" am";
		}
	}
	
	this.fromISO = function(string) {
	    var regexp = "([0-9]{4})(-([0-9]{2})(-([0-9]{2})" +
	        "(T([0-9]{2}):([0-9]{2})(:([0-9]{2})(\.([0-9]+))?)?" +
	        "(Z|(([-+])([0-9]{2}):([0-9]{2})))?)?)?)?";
	    var d = string.match(new RegExp(regexp));
	
	    var offset = 0;
	    var date = new Date(d[1], 0, 1);
	
	    if (d[3]) { date.setMonth(d[3] - 1); }
	    if (d[5]) { date.setDate(d[5]); }
	    if (d[7]) { date.setHours(d[7]); }
	    if (d[8]) { date.setMinutes(d[8]); }
	    if (d[10]) { date.setSeconds(d[10]); }
	    if (d[12]) { date.setMilliseconds(Number("0." + d[12]) * 1000); }
	    if (d[14]) {
	        offset = (Number(d[16]) * 60) + Number(d[17]);
	        offset *= ((d[15] == '-') ? 1 : -1);
	    }
	
	    offset -= date.getTimezoneOffset();
	    time = (Number(date) + (offset * 60 * 1000));
	    date.setTime(Number(time));
	    return date;
	}
	
	this.ajax = function(method, url, data, callback){
		var msg = 'Loading...'
		if (method == 'POST')msg = 'Sending...';
		if (data){
			if (hangplan.user.uid){
				data.token = hangplan.user.getToken();
				data.uid = hangplan.user.uid;
			}
		}
		hangplan.working(true, msg);
		$.ajax({
			type: method,
			url: url,
			data: data,
			cache: false,
			success: function(data){
				hangplan.working(false);
				if (data.error){
					hangplan.handleError(data.error);
					return;
				}
				callback(data);
			}
		});
	}
	
	this.handleError = function(err){
		hangplan.working(false);
		
		if (!err)err = 'A problem occurred trying to reach the Interent. Please check your connection and try again.';
		
		if (navigator.notification){
			navigator.notification.alert(err, null, 'Error');
		}else{
			alert(err);	
		}
	}	
}).apply(hangplan);

$(document).ready(function(){
    hangplan.init('#container');
});