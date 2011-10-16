var hangplan = {};
(function() {
    //Basic environment properties
    this.view = { 'container' : null };
	this.server = 'http://hangplan.com/';
	this.secureServer = 'https://hangplan.herokuapp.com/';	
	
    //Logged in user object
    this.user = {
    	uid : '',
    	tokenBase: '',
    	display: '',
    	following: [],
    	getImage: function(size, name){
    		if (!name)name = this.display;
    		return hangplan.server + 'user/' + name + '/pic/' + size;
    	},
    	getToken: function(base){
    		var tb = base?base:this.tokenBase;
    		return SHA1(tb + (new Date()).getUTCDate().toString());
    	},
    	isFollowing: function(qrcode){
    		for(var i = 0; i < hangplan.user.following.length; i++){
    			if (hangplan.user.following[i].qrcode == qrcode)return true;
    		}	
    		return false;
    	},
    	extend: function(data){
    		this.uid = data.uid;
    		this.tokenBase = data.tokenBase;
    		this.display = data.display;	
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
    	
       	document.addEventListener('deviceready', hangplan.deviceReady, false);       
       	//document.addEventListener("backbutton", hangplan.backbutton, false);
        //document.addEventListener("menubutton", hangplan.menubutton, false);
        
        if (window.location.hash == '#m')hangplan.deviceReady();
    };
    
    this.deviceReady = function(){
        hangplan.login();  
        /*
        FB.init({ appId: "223798634351683", nativeInterface: PG.FB });
        FB.Event.subscribe('auth.login', function(response) {
            console.log('auth.login event');
        });
        
        FB.Event.subscribe('auth.logout', function(response) {
            console.log('auth.logout event');
        });
        
        FB.Event.subscribe('auth.sessionChange', function(response) {
            console.log('auth.sessionChange event');
        });
        
        FB.Event.subscribe('auth.statusChange', function(response) {
            console.log('auth.statusChange event');
        });
        */
    };
    
    this.login = function(){
    	var ud = window.localStorage.getItem('hangplan-user');
    	if (ud){
    		var userData = JSON.parse(ud);
    		hangplan.user.extend(userData);
    		hangplan.load();
    	}else{
    		hangplan.view.container.pageTurner('reroot', 'homePage');
    		hangplan.load();
    		$('#btnLogin').live('touchstart', function(){
    			FB.login(function(e) {
                        hangplan.load();
                    },
                    { perms: "email" }
                );
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
	};
	
	this.updateCalendar = function(){
		//determine if/when to do a refresh
		hangplan.ajax('GET', 'data.json', null, function(data){
			data = JSON.parse(data);
			console.log(data);
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