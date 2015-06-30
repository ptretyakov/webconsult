// Generated by CoffeeScript 1.9.3
window.App = {
  Models: {},
  Views: {},
  Collections: {},
  InitViews: {},
  InitModels: {},
  InitCollections: {},
  Objects: {
    socket: {}
  },
  Functions: {},
  Data: {
    serverhost: 'https://webconsult-ptretyakov.c9.io/',
    sockethost: 'https://webconsult-node-server-ptretyakov.c9.io'
  }
};

App.Functions.getSocket = function() {
  if (Object.keys(App.Objects.socket)) {
    console.log('Инициализация сокета');
    return App.Objects.socket = io(App.Data.sockethost);
  } else {
    console.log('Возвращаем объект сокета');
    return App.Objects.socket;
  }
};