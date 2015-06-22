// Generated by CoffeeScript 1.4.0

window.App = {
  Models: {},
  Views: {},
  Collections: {},
  InitViews: {},
  InitModels: {},
  InitCollections: {}
};

App.Models.Chat = Backbone.Model.extend({
  initialize: function() {
    return console.log("Initialize chat");
  }
});

App.Views.Chat = Backbone.View.extend({
  el: '#el',
  socket: {},
  initialize: function() {
    console.log('Инициализируем соккеты');
    return this.initSockets();
  },
  initSockets: function() {
    this.socket = io('http://127.0.0.1:1337');
    return this.socket.emit('addConsultant');
  }
});

App.InitModels.Chat = new App.Models.Chat();

App.InitViews.Chat = new App.Views.Chat({
  model: App.InitModels.Chat
});
