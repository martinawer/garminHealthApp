using Toybox.WatchUi;
using Toybox.Timer;
using Toybox.Sensor;
using Toybox.Position;
using Toybox.System;
using Toybox.Communications;

class connectIQHealthAppView extends WatchUi.View {
    var dataTimer = new Timer.Timer();
    //Refactor to background task

    //HTTP Endpoint
    var url = "<your URL>";

    //time interval between data submits in ms
    var timer = 5000;

    function initialize() {
        View.initialize();
        dataTimer.start(method(:timerCallback), timer, true);
    }

    function timerCallback() {
        var sensorInfo = Sensor.getInfo();
        var positionInfo = Position.getInfo();
        var systemInfo = System.getSystemStats();

        var xAccel = 0;
        var yAccel = 0;
        var heartRate = 0;
        var altitude = 0;
        var speed = 0;
        var battery = 0;
        var isCharging = false;

        //Collect Data
        //Accelerometer
        if (sensorInfo has :accel && sensorInfo.accel != null) {
            var accel = sensorInfo.accel;
            xAccel = accel[0];
            yAccel = accel[1];
        }
        else {
            xAccel = 0;
            yAccel = 0;
        }

        //Heartrate
        if (sensorInfo has :heartRate && sensorInfo.heartRate != null) {
            heartRate = sensorInfo.heartRate;
        }
        else {
            heartRate = 0;
        }

        //Altitude
        if (sensorInfo has :altitude && sensorInfo.altitude != null) {
            altitude = sensorInfo.altitude;
        }
        else {
            altitude = 0;
        }
        
        //Power
        if(systemInfo has :battery && systemInfo.battery != null) {
            battery = systemInfo.battery;
        } else {
            battery = 0;
        }

        //isCharging
        if(systemInfo has :charging && systemInfo.charging != null) {
            isCharging = systemInfo.charging;
        } else {
            isCharging = false;
        }

        //Send data to the REST API
        var params = {
            "heart_rate" => heartRate.toNumber(),
            "xAccel" => xAccel.toNumber(),
            "yAccel" => yAccel.toNumber(),
            "altitude" => altitude.toFloat(),
            "battery" => battery.toNumber(),
            "isCharging" => isCharging,
        };
        //insert auth Token if needed
        var authToken = "<authToken>";

        var headers = {
            "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON,
            "Authorization" => authToken
        };

        var options = {
            :headers => headers,
            :method => Communications.HTTP_REQUEST_METHOD_POST,
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };
        
        Communications.makeWebRequest(url, params, options, method(:onReceive));

    }

       // set up the response callback function
    function onReceive(responseCode, data) {
       if (responseCode == 200) {
           System.println("Request Successful");                   // print success
       }
       else {
           System.println("Response: " + responseCode);            // print response code
       }
   }


    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}
