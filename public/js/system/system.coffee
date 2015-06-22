window.App = 
	Models 		: {}
	Views 		: {}
	Collections : {}

	InitModels		: {}
	InitViews 		: {}
	InitCollections	: {}

# Создаем модель чата
App.Models.Chat = Backbone.Model.extend
	urlRoot : '/consultants'

# Создаем представление чата
App.Views.Chat = Backbone.View.extend
	el 			: '#ok_con_web_chat'
	$ok 		: $ '#ok_button'	# Селектор кнопки чата
	open 		: false				# Открыт ли чат
	online 		: false				# Индикатор кнопки (есть ли вообще консультанты)
	client 		: {}				# Данные пользователя \
	status 		: 'offline'			# Статус чата
	consults 	: 0					# Количество консультантов онлайн

	initialize 	: ->
		console.log 'init view chat'	
		@updateSystem()
		# Запускаем сокеты
		@registerSocket()

	registerSocket : ->
		console.log "Initialize socket"		
		# Регестрируем
		@socket 	= io 'http://127.0.0.1:1337'
		
		# Отравеляем запросы
		@socket.emit 'addClient'
		
		############### Ставим прослушки ###################
		@socket.on 	'takeCountConsultants' , (data) =>
			@takeCountConsultants data
		###################################################

	# Получаем от ноды количество консультантов онлайн
	takeCountConsultants : (data) ->
		console.info 'Получили количество консультантов' , data
		# Если есть количество консультантов в онлайне
		if 'count' of data
			count = parseInt data.count
			if count
				@online = true
			else
				@online = false				
		else
			@online = false		# Нет в онлайне консультантов					

		@updateSystem()

	# Основаня логика определяющая состояние системы
	updateSystem : () ->
		# Если ввобще нет консультантов устанвливаем оффлайн форму
		if not @online
			@status = 'offline'	# При октрытии чата открываем оффлайн форму	
			@switchChatButton 0 # И выключаем кнопку на чате
		else
			# Если есть консультанты
			@switchChatButton 1	# В любом случае включаем лампочку на конпке


	switchChatButton : (command) ->
		if command			
			console.log 'Online'
			@$ok.removeClass 'ok_offline_button'
			@$ok.addClass 'ok_online_button'
		else
			console.log 'Offline'
			@$ok.removeClass 'ok_online_button'
			@$ok.addClass 'ok_offline_button'

	events :
		'click #ok_button' 	: 	'okClick'	# Открыть / закрыть панель чата
		'click #ok_submit'	:	'okSubmit'

	# Отправка offline сообщения
	okSubmit : (e) ->
		# Получаем данные оффлайн формы
		$element = $ e.currentTarget
		$form 	= $element.parent 'form'
		data 	= JSON.stringify $form.serializeArray()

		
		console.log data

	okClick : ->
		if @open
			@hideChat()
			@open = false
		else
			@showChat()
			@open = true

	showChat : () ->
		ok_position = 'ok_left_center'		
		template 	= $('#' + @status + '_tmpl').html()

		$('#iframe').html template

		$('#ok_consultant').css 'display' , 'block'
		switch ok_position
			when 'ok_left_center'
				$('#ok_con_web_chat').animate
					'left': '0'
				, 250

	hideChat : () ->
		ok_position = 'ok_left_center'

		switch ok_position
			when 'ok_left_center'
				$('#ok_con_web_chat').animate
					'left': '-340px'
				, 450 , ->
					$('#ok_consultant').css 'display', 'none'

		
		

############################### Инициализация ##########################
# Инициализируем модель чата
App.InitModels.Chat = new App.Models.Chat()

# Инициализируем представление чата
App.InitViews.Chat 	= new App.Views.Chat
	model : App.InitModels.Chat	
################################ TMP DATA ##############################

# Отображение кнопки онлайн
#$('#ok_button').addClass 'ok_online_button'
# Отображение кнопки онлайн
#$('#ok_button').addClass 'ok_offline_button'

showChat = (tmpl_name) ->
	ok_position = 'ok_left_center'
	template 	= $('#' + tmpl_name).html()

	$('#iframe').html template

	$('#ok_consultant').css 'display' , 'block'
	switch ok_position
		when 'ok_left_center'
			$('#ok_con_web_chat').animate
				'left': '0'
			, 250

hideChat = () ->
	ok_position = 'ok_left_center'

	switch ok_position
		when 'ok_left_center'
			$('#ok_con_web_chat').animate
				'left': '-340px'
			, 450 , ->
				$('#ok_consultant').css 'display', 'none'