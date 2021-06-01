package com.timozacherl.plugins.cap-siri-shortcuts;

import com.getcapacitor.JSObject;
import com.getcapacitor.NativePlugin;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;

@CapacitorPlugin(
    name = "SiriShortcuts"
)
public class SiriShortcuts extends Plugin {

    @PluginMethod
    public void donate(PluginCall call) {
        String value = call.getString("value");

        JSObject ret = new JSObject();
        ret.put("value", value);
        call.success(ret);
    }
}
