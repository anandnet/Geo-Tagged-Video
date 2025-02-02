package io.flutter.plugins;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry;

/**
 * Generated file. Do not edit.
 * This file is generated by the Flutter tool based on the
 * plugins that support the Android platform.
 */
@Keep
public final class GeneratedPluginRegistrant {
  public static void registerWith(@NonNull FlutterEngine flutterEngine) {
    ShimPluginRegistry shimPluginRegistry = new ShimPluginRegistry(flutterEngine);
    flutterEngine.getPlugins().add(new io.flutter.plugins.camera.CameraPlugin());
      com.arthenica.flutter.ffmpeg.FlutterFFmpegPlugin.registerWith(shimPluginRegistry.registrarFor("com.arthenica.flutter.ffmpeg.FlutterFFmpegPlugin"));
      io.github.ponnamkarthik.toast.fluttertoast.FluttertoastPlugin.registerWith(shimPluginRegistry.registrarFor("io.github.ponnamkarthik.toast.fluttertoast.FluttertoastPlugin"));
      com.baseflow.geolocator.GeolocatorPlugin.registerWith(shimPluginRegistry.registrarFor("com.baseflow.geolocator.GeolocatorPlugin"));
      com.baseflow.googleapiavailability.GoogleApiAvailabilityPlugin.registerWith(shimPluginRegistry.registrarFor("com.baseflow.googleapiavailability.GoogleApiAvailabilityPlugin"));
      io.flutter.plugins.googlemaps.GoogleMapsPlugin.registerWith(shimPluginRegistry.registrarFor("io.flutter.plugins.googlemaps.GoogleMapsPlugin"));
      com.lyokone.location.LocationPlugin.registerWith(shimPluginRegistry.registrarFor("com.lyokone.location.LocationPlugin"));
      com.baseflow.location_permissions.LocationPermissionsPlugin.registerWith(shimPluginRegistry.registrarFor("com.baseflow.location_permissions.LocationPermissionsPlugin"));
    flutterEngine.getPlugins().add(new io.flutter.plugins.pathprovider.PathProviderPlugin());
      com.rioapp.permissions_plugin.PermissionsPlugin.registerWith(shimPluginRegistry.registrarFor("com.rioapp.permissions_plugin.PermissionsPlugin"));
      flutter.plugins.screen.screen.ScreenPlugin.registerWith(shimPluginRegistry.registrarFor("flutter.plugins.screen.screen.ScreenPlugin"));
    flutterEngine.getPlugins().add(new io.flutter.plugins.videoplayer.VideoPlayerPlugin());
  }
}
