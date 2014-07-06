function authToken() {
    return $('meta[name="csrf-token"]').attr('content');
}

$(document).ready(function() {

    var controller = new Shogogo.Controller();

    var searchController = new Shogogo.SearchController();

    searchController.defineView({
        searchBox: document.querySelector('#search_box'),
        searchMessage: document.querySelector('#search_message'),
        searchContainer: document.querySelector('.search_container'),
        classSearchContainerFavorites: document.querySelector('.search_with_faves'),
        classSidebarFavorites: document.querySelector('.faves'),
        classSidebarNoFavorites: document.querySelector('.nofaves'),
        classLogin: document.querySelector('.login')
    });

    var sessionsController = new Shogogo.SessionsController();
    
    sessionsController.defineView(new Shogogo.SessionsView({
        loginForm: document.querySelector(".local_shows_list"),
        sidebar: document.querySelector("#favorites-menu"),
        overlay: document.querySelector(".overlay"),
        loginLink: document.querySelector("#login_link")
    }));

    sessionsController.listeners();

    var bandView = new BandView();
    var favoritesController = new FavoritesController();
    var favoritesView = new FavoritesView();
    var localShowsView = new LocalShowsView();
    var favoriteList = new FavoriteList();
    var localShows = new LocalShows();
    var searchBox = new SearchBox();
    var artistObject;

    $('.overlay').hide();

    $( document ).on( "submit", "#login_form", function(e) {
        e.preventDefault();
        sessionsController.authenticateUser();
    });

    $("#search_box")
        .suggest({ filter:'(all type:/music/artist)',
            flyout: false,
            css: { pane: "suggest_pane",
                   list: "suggest_list",
                 status: "suggest_status" },
                  "key": "AIzaSyBCuOTLMAC-WOcLzyv2YeKvCvwaDPI8NhI"
        })
        .bind('fb-select', function(e) {
            var artistName = searchBox.getArtistName();
            var preparedArtistName = searchBox.preparedArtistQuery(artistName);
            $('#search_message').hide();
            $('.login').hide();
            $('input:text').focus(function(){
            $(this).val('');
         });
            $.getJSON(preparedArtistName).done(function(artistInfo) {
                var artistData = artistInfo.performers[0];
                artistObject = searchBox.parseArtistInfo(artistData);
                bandView.draw(artistObject);
            });
    });

    $('#search_box').on('click', function() {
        newSearchController.clearSearch();
        $('#band_container').fadeOut();
    });

    $('#band_container').on('click', '#add_band', function(e) {
        e.preventDefault();
        favoritesView.append_draw(artistObject);
        $.post("/favorites", { favorite: { seatgeek_id: artistObject.id, name: artistObject.name, image_url_small: artistObject.image_url_small }, authenticity_token: authToken() })
            .done(function(data) {
                var favorite_id = data.id;
                $('.favorites_band_item').last().attr( "fav-id", favorite_id );
            });
        bandView.clearSearch();
    });

    $( document ).on( "click", ".favorites_band_remove", function(e) {
        e.preventDefault();
        var band = $(this).closest('.favorites_band_item');
        favoritesController.removeFavorite(band);
    });

    $(document).on( "click", ".favorites_save", function(e) {
        e.preventDefault();
        sessionsController.getUserForm();
    });

    $( document ).on( "submit", "#user_create", function(e) {
        e.preventDefault();
        if (!phoneValidator()) {
            return false;
        }
        sessionsController.postUserForm();
    });
});