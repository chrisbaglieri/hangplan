var biqr = {};
(function() {
    //Basic environment properties
    this.view = { 'container' : null };
    this.gifs = 'http://s3.amazonaws.com/biqr/gifs/';
	
	this.server = 'http://biqr.net/';
	this.secureServer = 'https://biqr.herokuapp.com/';	
	
    //Logged in user object
    this.user = {
    	uid : '',
    	tokenBase: '',
    	display: '',
    	following: [],
    	getImage: function(size, name){
    		if (!name)name = this.display;
    		return biqr.server + 'user/' + name + '/pic/' + size;
    	},
    	getToken: function(base){
    		var tb = base?base:this.tokenBase;
    		return SHA1(tb + (new Date()).getUTCDate().toString());
    	},
    	isFollowing: function(qrcode){
    		for(var i = 0; i < biqr.user.following.length; i++){
    			if (biqr.user.following[i].qrcode == qrcode)return true;
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
    	biqr.view.container = $(containerDiv);
		biqr.view.container.pageTurner({ bindMobileTouchEvents: false });
		
		$(containerDiv).ajaxError(function(xhr, status, settings, err){
			biqr.handleError(err);
		});
    	
       	document.addEventListener('deviceready', biqr.deviceReady, false);       
       	document.addEventListener("backbutton", biqr.backbutton, false);
        document.addEventListener("menubutton", biqr.menubutton, false);
    };
    
    this.deviceReady = function(){
        biqr.login();
		window.setInterval(biqr.newadd, 60000);           
    };
    
    this.login = function(){
    	var ud = window.localStorage.getItem('biqr-user');
    	if (ud){
    		var userData = JSON.parse(ud);
    		biqr.user.extend(userData);
    		biqr.load();
    	}else{
    		biqr.view.container.pageTurner('reroot', 'loginPage');
    		
    		$('#btnLogin').live('click', function(){
    			var data = {
					email: $('#email').get(0).value,
					pw: $('#pw').val()
				};
				
				biqr.ajax('POST', biqr.secureServer + 'api/user/authenticate', data, function(data){
					$('#pw').val('');					
					window.localStorage.setItem('biqr-user', JSON.stringify(data));
					biqr.user.extend(data);
					biqr.load();
				});
    		});
    	}
    }
    
    this.logout = function(){
    	biqr.user.clear();
    	window.localStorage.removeItem('biqr-user');
    	$('.listing ul').html('');
    	window.location.reload();
    }
    
    this.load = function(){
        var me = this;
        biqr.view.container.pageTurner('reroot', 'homePage');      
		
		$('#btnScan').click(function(){ biqr.scan(); });
		$('#btnLogout').click(function(){ biqr.logout(); });
		
		$('.listing ul li').live('click', function(){
			if ($(this).attr('qrcode')){
				biqr.detailsLoad($(this).attr('qrcode'), true);
				return;	
			}
		});
		
		$('#followingPage').bind('pageshow.pageTurner', function(){
			biqr.view.container.pageTurner('purge');
			if ($('#followingPage .listing ul li').length == 0)biqr.updateList('following', 1);
		});		
		
		$('#profilePage').bind('pageshow.pageTurner', function(){
			biqr.view.container.pageTurner('purge');
			if ($('#profilePage .listing ul li').length == 0)biqr.updateList('created', 1);
			$('#profileData img').attr('src', biqr.user.getImage(100));
			$('#profileData h3').html(biqr.user.display);
		});
		
		$('#btnRegister').live('click', function(){
			biqr.register();
		});
		
		$('a.image').live('click', function(){
			var name = $(this).attr('text');
			var src = $(this).attr('src');
			
			biqr.view.container.pageTurner('create', 'imageTemplate', { name: name, src: src }, 'img' + name, false);
			biqr.view.container.pageTurner('navigate', 'img' + name);
		});
		
		$('#gifdexPage').bind('pageshow.pageTurner', function(){
			if ($('#gifdexPage .content ul li').length == 0){
				biqr.ajax('GET', biqr.server + 'api/gifdex', null, function(data){
					$('#gifTemplate').tmpl(data).appendTo('#gifdexPage .content ul');
				});
			}
		});		
		
		$('a.profile').live('click', function(){
			var name = $(this).html();
			var src = biqr.user.getImage(200, name);
			
			biqr.view.container.pageTurner('create', 'imageTemplate', { name: name, src: src }, 'profile' + name, false);
			biqr.view.container.pageTurner('navigate', 'profile' + name);
		});		
		
		$('.listing div.button').click(function(){
			var page = $(this).data('page')?$(this).data('page'):1;
			var list = $(this).parent().get(0).id;
			biqr.updateList(list, page, false);
		});
		
		$('#gifdexPage .content ul li a.insert').live('click', function(){
			var val = $('#comment').val();
			var last = val.charAt(val.length - 1);
			if ((last != ' ')&&(last != ''))val += ' ';
			val += $(this).attr('gif');
			$('#comment').val(val);
		});
	};
	
	this.backbutton = function(){
		biqr.view.container.pageTurner('back');
	};
	
	this.menubutton = function(){
		biqr.view.container.pageTurner('root');
	};
		
	this.updateList = function(list, page, force){
		var listObj = $('#' + list);
		var paging = '/' + page;
		paging += (list == 'following')?'/1000':'/10';
		biqr.ajax('GET', biqr.server + 'api/user/' + list + paging, {}, function(data){
			if (list == 'following')biqr.user.following = data;
			if (force)$('#' + list + ' ul').html('');
			$('#listingTemplate').tmpl(data).appendTo('#' + list + ' ul');
			listObj.data('ll', (new Date()).getTime().toString());
			listObj.find('div.button').data('page', page + 1);
			if (data.length < 10)listObj.find('div.button').hide();
		});
	}
	
	this.scan = function(){
		if (window.plugins){
			biqr.working(true);
			window.plugins.barcodeScanner.scan(BarcodeScanner.Type.QR_CODE, function(result) {
		        biqr.handleCapture(result);
		        biqr.working(true);
			}, function(error) {
				biqr.working(false);
			}, { yesString: "Install" });
		}else{
	   		biqr.handleCapture(window.location.hash.replace('#',''));
		}		
	}	
	
	this.handleCapture = function(result){
		var id = '';
		var regex = new RegExp('http://biqr\.net/[A-z0-9]{10}$');
		if (regex.test(result)){
			id = result.substr(result.length - 10);
		}else{
			id = 'h:' + SHA1(result);
		}
		biqr.detailsLoad(id, result);
	};
	
	this.detailsLoad = function(id, content, reroute){	
		biqr.ajax('GET', biqr.server + 'api/' + id, null, function(data){
			if (data.length > 0){
				biqr.detailsShow(data[0], reroute);
			}else{
				biqr.view.container.pageTurner('create', 'noooTemplate', { hash: id.substr(2), body: content}, 'nooo', false);
				biqr.view.container.pageTurner('navigate', 'nooo');
			}
		});	
	}
	
	this.detailsShow = function(data, reroute){
		biqr.view.container.pageTurner('create', 'detailTemplate', data, data._id, false);
		var path = data._id;
		
		if (reroute)path = '/' + path;
		biqr.view.container.pageTurner('navigate', path);
		
		biqr.loadComments(data._id, 1);
		$('#btnMore').click(function(){
			biqr.loadComments(data._id, $('#qrcomments').data('pages') + 1);	
		});
		
		if (biqr.user.isFollowing(data._id)){
			$('#btnFollow').hide();
			$('#btnUnfollow').show();
		}
		
		$('#btnFollow').click(function(){ biqr.follow(data); });
		$('#btnUnfollow').click(function(){
			var message = 'Are you sure you want to unfollow this code?';
			if (navigator.notification){
				navigator.notification.confirm(message, function(index){
					if (index != 1)return;
					biqr.follow(data, true);						
				}, 'Continue?');
			}else{
				if (confirm(message))biqr.follow(data, true);
			} 
		});
		
		$('#btnComment').click(function(){
			if (!$('#comment').val())return;
			var obj = {
				comment: $('#comment').val()	
			}
			biqr.ajax('POST', biqr.server + 'api/' + data._id + '/comment', obj, function(data){
				$('#commentTemplate').tmpl(data.comment).insertAfter('#frmComment');
				$('#comment').val('');
			});
		});		
	}
	
	this.register = function(){
		if (!$('#register-title').val()){
			biqr.handleError('Please provide a title!');
			return;
		}
		
		var data = {
			'qrcode[hash]': $('#register-hash').val(),
			'qrcode[body]': $('#register-body').val(),
			'qrcode[title]': $('#register-title').val()
		};
		biqr.ajax('POST', biqr.server + 'api/new', data, function(data){
			biqr.detailsLoad(data.qrcode._id, data.qrcode.body, true);
		});
	}
	
	this.follow = function(qrdata, unfollow){
		var url = biqr.server + 'api/user/follow';
		if (unfollow)url = biqr.server + 'api/user/unfollow';
		var data = {
			title: qrdata.title,
			qrcode: qrdata._id
		};
		biqr.ajax('POST', url, data, function(data){
			if (data.following){
				$('#btnFollow').hide();
				$('#btnUnfollow').show();	
			}else{
				$('#btnFollow').show();
				$('#btnUnfollow').hide();
			}
			biqr.updateList('following', 1, true);
		});		
	};
	
	this.loadComments = function(id, page){
		$('#btnMore').html('<img src="images/loading.gif" alt="loading..."/>');
		var url = biqr.server + 'api/' + id + '/comments/' + page + '/25';
		biqr.ajax('GET', url, null, function(data){
			if (data.length < 24){
				$('#btnMore').hide();
			}else{
				$('#btnMore').show();
			}
			$('#commentTemplate').tmpl(data).insertBefore('#btnMore');		
			$('#qrcomments').data('pages', page);
			$('#btnMore').html('Load More Comments');
		});
	};
	
	this.email = function(to, subject){
		if (window.plugins.emailComposer){
			window.plugins.emailComposer.showEmailComposer(subject, '', to);
		}else{
			window.location	= 'mailto:' + to + '?subject=' + subject;
		}	
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
	
	
	this.giflib = ['aah','agree','agree2','applause','bitchplease','bitchplease2','blah','boohoo','bringit','checkyoself','couch','cringe','cuckoo','whatever','deal','donotwant','donotwant2','dontwanttosee','duh','puh','eyeroll','gonnabegood','gonnabegood2','headdesk','hitthat','howyoudoin','howyoudoin2','imout','imout2','ineedadrink','iseewhatyoudid','iseewhatyoudid2','iwillkillu','listening','lol','moveon','meh','nothang','nowwhat','ohnoyoudidnt','omg','orly','orly2','reading','reading2','sad','shimmy','shutup','shutup2','smh','smokeup','snooki','snowsucks','spittake','srsly','thumbsup','timeout','turtletime','wellwell','wtf','yay','icanseethat'];
	this.gifpath = 'http://s3.amazonaws.com/biqr/gifs/';
	
	this.formatBody = function(body){
		if (!body)return;
		if (body.indexOf(';http://biqr.net') > -1)body = body.substr(0, body.length - 27);
		body = biqr.linkify(body);
		
		var regex = /\$(\w+)/g;
		body = body.replace(regex, function(full, inner){
			if ($.inArray(inner, biqr.giflib) > -1){
				return '<a class="image" src="' + biqr.gifpath + inner + '.gif" text="' + inner + '">' + inner + '</a>';	
			}
			return inner;
		});
		return unescape(body);
	};
	
	this.linkify = function(inputText) {
	    var replaceText, replacePattern1, replacePattern2, replacePattern3;
	
	    //URLs starting with http://, https://, or ftp://
	    replacePattern1 = /(\b(https?|ftp):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/gim;
	    replacedText = inputText.replace(replacePattern1, '<a href="$1" target="_blank">$1</a>');
	
	    //URLs starting with "www." (without // before it, or it'd re-link the ones done above).
	    replacePattern2 = /(^|[^\/])(www\.[\S]+(\b|$))/gim;
	    replacedText = replacedText.replace(replacePattern2, '$1<a href="http://$2" target="_blank">$2</a>');
	
	    //Change email addresses to mailto:: links.
	    replacePattern3 = /(\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,6})/gim;
	    replacedText = replacedText.replace(replacePattern3, '<a href="mailto:$1">$1</a>');
	
	    return replacedText
	};
	
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
			if (biqr.user.uid){
				data.token = biqr.user.getToken();
				data.uid = biqr.user.uid;
			}
		}
		biqr.working(true, msg);
		$.ajax({
			type: method,
			url: url,
			data: data,
			cache: false,
			success: function(data){
				biqr.working(false);
				if (data.error){
					biqr.handleError(data.error);
					return;
				}
				callback(data);
			}
		});
	}
	
	this.handleError = function(err){
		biqr.working(false);
		
		if (!err)err = 'A problem occurred trying to reach the Interent. Please check your connection and try again.';
		
		if (navigator.notification){
			navigator.notification.alert(err, null, 'Error');
		}else{
			alert(err);	
		}
	}	
}).apply(biqr);

$(document).ready(function(){
    biqr.init('#container');
});