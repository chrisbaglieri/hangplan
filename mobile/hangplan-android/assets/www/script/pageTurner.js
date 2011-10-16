(function($){    
    var methods = {
		init : function(options){
		    return this.each(function(){
			var settings = {
			    'speed': 'fast',
			    'backSymbol': '..',
			    'rootSymbol': '/',
			    'remoteSymbol': '//',
			    'topSymbol': '^',
			    'pageAttr': 'page',
			    'pageSelector': 'div.page',
			    'headerBarSelector': '#header',
			    'headerTitleSelector': 'h1',
			    'pageLinkSelector': 'a[page], .button[page]',
			    'backButtonSelector': 'a[page=".."]',
			    'homeButtonSelector': 'a[page="/"]',
				'topButtonSelector': 'a[page="^"]',
			    'pageHeaderSelector': 'div.header',
			    'pageTabSelector': 'div.tabs',
			    'pageTemplateSelector': 'script[type="text/x-jquery-tmpl-page"]',
			    'rootEvent': 'root.pageTurner',
			    'backEvent': 'back.pageTurner',
			    'purgeEvent': 'purge.pageTurner',
			    'pageShowEvent': 'pageshow.pageTurner',
			    'pageLoadEvent': 'pageload.pageTurner',
			    'pageCreateEvent': 'pagecreate.pageTurner',
			    'pageLinkClickEvent': 'click.pageTurner',
			    'tabBarSelector': '#tabs',
			    'defaultHomePage': '',
			    'purgeOnRoot': true,
			    'logEvents': false,
			    'bindMobileTouchEvents': true
			};
			
			var me = $(this);
			me.win = $(window);
			
			var data = $.extend(settings, options);
			data.history = [];
			data.headerBar = $(data.headerBarSelector);
			data.tabBar = $(data.tabBarSelector);
			data.headerTitle = data.headerBar.find(data.headerTitleSelector);
			data.backButton = data.headerBar.find(data.backButtonSelector);
			data.homeButton = data.headerBar.find(data.homeButtonSelector);
			data.topButton = data.headerBar.find(data.topButtonSelector);
			data.defaultHeaderTitle = data.headerTitle.html();
			me.data(data);
			
			 
			//Bind page hyperlinks
			$(data.pageLinkSelector).unbind(data.pageLinkClickEvent);
			$(data.pageLinkSelector).live(data.pageLinkClickEvent, function(){
			    var page = $(this).attr(data.pageAttr);
			    me.pageTurner('navigate', page);
			}); 
			
			//Load page templates
			if ($.template){
			    me.find(data.pageTemplateSelector).each(function(){
					$(this).template(this.id);
			    });
			}
			
			//Bind page purgings
			if (data.purgeOnRoot){
			    me.bind('root.pageTurner', function(){ me.pageTurner('purge'); });
			}
			
			//Bind eventlogging
			if (data.logEvents){
			    me.bind({
					'back.pageTurner': internal.logEvent,
					'root.pageTurner': internal.logEvent,
					'pageshow.pageTurner': internal.logEvent,
					'pageload.pageTurner': internal.logEvent,
					'pagecreate.pageTurner': internal.logEvent,
					'purge.pageTurner': internal.logEvent
			    });
			}
			
			if (data.bindMobileTouchEvents){
			    me.find(data.pageLinkSelector).bind({
					'touchstart' : function(){ $(this).addClass('.active'); },
					'touchend' : function(){ $(this).removeClass('.active'); }
			    });
			}
			
			me.win.resize(function(){
			    var height = me.height() - data.headerBar.height() - (data.tabBar?data.tabBar.height():0);
			    var page = internal.current(me);
			    if (page)page.height(height);
			    me.win.trigger('scroll');
			});
			
			me.win.scroll(function() {
				var st = me.win.scrollTop();
    			/*data.headerBar.css('top', st + "px");
    			data.tabBar.css('top', st + me.win.height() - data.tabBar.height());*/
    			
    			if (st != 0){
    				data.topButton.show();	
    				data.homeButton.hide();	
    			}else{
    				data.topButton.hide();
    				if (internal.canBack(me))data.homeButton.show();	
    			}
			});
			
			//Navigate to root
			if (data.defaultHomePage){
			    me.pageTurner('navigate', data.defaultHomePage);
			}else{
			    me.pageTurner('navigate', me.find(data.pageSelector).first().get(0).id);
			}
		    });
		},
		
		navigate : function(page){
		    return this.each(function(){
				var me = $(this);
				var data = me.data();
				if (page.indexOf(data.remoteSymbol) == 0){
				    var bits = page.substr(2).split('#');
				    $(this).pageTurner('load', bits[0], bits[1]);
				}else if (page == data.rootSymbol){
				    $(this).pageTurner('root');
				}else if (page == data.backSymbol){
				    $(this).pageTurner('back');
				}else if (page == data.topSymbol){
				   	$('html').animate({scrollTop:0}, 'slow');
					$(window).trigger('scroll');    
				}else if (page.indexOf(data.rootSymbol) == 0){
				    $(this).pageTurner('root', page.replace('/',''));
				}else{
				    $(this).pageTurner('show', page);
				}
				$(window).scrollTop(0);
				$(window).trigger('scroll');
		    });
		},
		
		back : function(left){
		    return this.each(function(){
				var me = $(this);
				var data = me.data();
				if (internal.count(me) <= 1)return;
				var current = data.history.pop();
				var previous = internal.current(me);
				internal.setChrome(me);
				if (previous.get(0).id == current.get(0).id)return;
				if (left){
					internal.left(current, previous, me);
				}else{
					internal.right(previous, current, me);
				}
				me.trigger(data.backEvent);
				internal.triggerPageShowEvents(me);
		    });
		},
		
		root : function(next){
		    return this.each(function(){
			var me = $(this);
			var data = me.data();	    
			if (internal.count(me) == 0){
			    me.pageTurner('show', root);
			    return;
			}else{
			    if (next){
					var root = data.history[0];   
					if (!next.jquery)next = $('#' + next);
					data.history = [ root, next, data.history.pop() ];
					me.pageTurner('back', next, true);
			    }else{
					var root = data.history[0];   
					data.history = [ root, data.history.pop() ];
					me.pageTurner('back');
			    }
			}
		    });
		},
		
		reroot : function(root){
		    return this.each(function(){
				var me = $(this);
				var data = me.data();
				if (!root.jquery)root = $('#' + root);
				data.history = [ root, data.history.pop() ];
				me.pageTurner('back');
		    });	    
		},
		
		getroot : function(root){
		    var roots = [];
			    this.each(function(){
				var me = $(this);
				var data = me.data();
				roots.push(data.history[0].get(0));
		    });
		    return roots;
		},
		
		show : function(page){
		    return this.each(function(){
				var me = $(this);
				var data = me.data();
				if (!page.jquery)page = me.find('#' + page);
				var previous = internal.current(me);
				if (previous){
				    if (page.get(0).id == previous.get(0).id)return;
				}
				data.history.push(page);
				internal.setChrome(me);
				internal.left(previous, internal.current(me), me);
				internal.triggerPageShowEvents(me);
				$('html, body').scrollTop(0).scrollLeft(0);
		    });
		},
		
		create : function(template, templateData, id, permanent){
		    if (!$.template)return null;
		    return this.each(function(){
				if (!template)return null;
				var me = $(this);
				var data = me.data();
				var page = $('<div class="page" />').attr('temp', permanent?'false':'true').appendTo(me);
				page.data(templateData);
				if (id){
					$('#' + id).remove();
					if (id)page.attr('id', id);	
				}
				$.tmpl(template, templateData).appendTo(page);
				$(window).trigger('resize');
				me.trigger(data.pageCreateEvent);
				return page;
		    });
		},
		
		load : function(url, id){
		    return this.each(function(){
				if (!url)return;
				var me = $(this);
				var data = me.data();
				$.get(url, function(html){
				    var pages = $('<div />').append($(html)).find(data.pageSelector);
				    pages.attr('temp', 'true').appendTo(me).end();
				    $(window).trigger('resize');
				    me.trigger(data.pageLoadEvent);
				    me.pageTurner('navigate', id);
				});
		    });
		},
		
		purge : function(){
		    return this.each(function(){
				var me = $(this);
				var data = me.data();
				me.find(data.pageSelector + '[temp="true"]').each(function(){
				    $(this).remove();
				});
				me.trigger(data.purgeEvent);
		    });
		},
		
		canBack : function(){
			var me = $(this);
		    if (internal.count(me) >= 2)return true;
		    return false;
		},
    }
    
    var internal = {
		right : function(previous, current, obj){
		    var data = obj.data();
		    previous.css('left', $(document).width() * -1);
		    if (!previous.is(':visible'))previous.css('display', 'block');
		    previous.animate({ left: 0 }, data.speed);
		    current.animate({ left: obj.width() }, data.speed, function(){ $(this).css('display', 'none'); });
		},
		
		left : function(previous, current, obj){
		    var data = obj.data();
		    current.css('left', obj.width() + 'px');
		    if (internal.count(obj) > 1)previous.animate({ left: (obj.width() * -1) }, data.speed, function(){ $(this).css('display', 'none'); });
		    if (!current.is(':visible'))current.css('display', 'block');
		    current.animate({ left: 0 }, data.speed);
		},	
		
		current : function(obj){
		    if (internal.count(obj) > 0)return obj.data().history[obj.data().history.length - 1];
		    return null;
		},
		
		count : function(obj){
		    return obj.data().history.length;
		},
		
		setChrome : function(obj){
		    var data = obj.data();		
		    var pageHeader = internal.current(obj).find(data.pageHeaderSelector);
		    if (pageHeader.length <= 0){
				data.headerBar.hide();
		    }else{
			    data.headerBar.show();
			    if (!pageHeader.html()){
					data.headerTitle.html(data.defaultHeaderTitle);
			    }else{
					data.headerTitle.html(pageHeader.html());
			    }
			
			    if (internal.canBack(obj)){
					data.backButton.show();
					data.homeButton.show();
			    }else{
					data.backButton.hide();
					data.homeButton.hide();
			    }			    
			    if (pageHeader.attr('hide')){
					var hidden = pageHeader.attr('hide');
					if (hidden.indexOf('back') > -1)data.backButton.hide();
					if (hidden.indexOf('home') > -1)data.homeButton.hide();	    
					
			    }
		    }
		    		  
		    var pageTabs = internal.current(obj).find(data.pageTabSelector);
		    if (pageTabs.length > 0){
		    	//data.tabBar.html(pageTabs.html());
		    	var buttons = data.tabBar.find('a');
			    var pid = internal.current(obj).get(0).id;
			    buttons.each(function(){ 
			    	$(this).width((100 / buttons.length) + '%'); 
			    	$(this).removeClass('active');
					if (pid == $(this).attr('match'))
						$(this).addClass('active');
				});
				data.tabBar.css('top', $(window).height() - data.tabBar.height());
				data.tabBar.show();
		    }else{
		    	data.tabBar.hide();
		    }
		},
		
		canBack : function(obj){
		    if (internal.count(obj) >= 2)return true;
		    return false;
		},
		
		triggerPageShowEvents : function(obj){
		    var data = obj.data();
		    $(window).trigger('resize');
		    internal.current(obj).trigger(data.pageShowEvent);
		    if (internal.count(obj) == 1)obj.trigger(data.rootEvent);
		},
		
		logEvent : function(event){
		    console.log(event.type + ': ' + event.target.id);
		}
    }
    
    $.fn.pageTurner = function(method) {  
		if (methods[method]) {
			return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
		}else if (typeof method === 'object' || ! method){
			return methods.init.apply(this, arguments);
		}else{
			$.error('Method ' +  method + ' does not exist on pageTurner');
			return null;
		}
    };
    
})(jQuery);