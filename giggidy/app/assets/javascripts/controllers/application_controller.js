Shogogo.Controller = function() {};

Shogogo.Controller.prototype = {
    init: function() {
        this._addControllers();
        this._defineViews();
        this._startListeners();
    },

    _addControllers: function() {
        this.favorites = new Shogogo.FavoritesController(new Shogogo.FavoritesPresenter());
        this.search = new Shogogo.SearchController(new Shogogo.SearchBox(new Shogogo.SeatGeekParser()));
        this.sessions = new Shogogo.SessionsController();
    },

    _defineViews: function() {
        this.sessions.defineView(new Shogogo.SessionsView(domElements), new Shogogo.SidebarView(domElements));
        this.search.defineView(new Shogogo.SearchView(domElements), new Shogogo.BandView(domElements));
        this.favorites.defineView(new Shogogo.SidebarView(domElements), new Shogogo.BandView(domElements));
    },

    _startListeners: function() {
        this.sessions.listeners();
        this.search.listeners();
        this.favorites.listeners();
    }
};