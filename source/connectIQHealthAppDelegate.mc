using Toybox.WatchUi;

class connectIQHealthAppDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new connectIQHealthAppMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}