import 'dart:async';
import 'dart:core';
import 'dart:convert' as convert;

import 'package:localstorage/localstorage.dart';

import 'package:usb_can/usb_can.dart' as usb_can;

abstract class Repository {
    Future<Map<String, dynamic>> setDbc(String strDbc);
    Future<Map<String, dynamic>> getDbc();
    Future<Map<String, dynamic>> syncMetaDatas(Map<String, dynamic> dbcInJson);
    void startSending();
    void stopSending();
    void loadAmmo(int id);
    void unloadAmmo(int id);
    void setConstStrategy(String sname, double value);
}

class CanRepository implements Repository {
    static final CanRepository _repository = new CanRepository._internal();
    factory CanRepository() {
        return _repository;
    }
    CanRepository._internal() {
        // var storage = LocalStorage('dbc');
        // storage.ready.then((s) {
        //   Map<String, dynamic> dbcInJson = storage.getItem('dbc');
        //   usb_can.syncMetaDatas(dbcInJson);
        // });
    }

    @override
    Future<Map<String, dynamic>> setDbc(String strDbc) async {
        Map<String, dynamic> dbcInJson = convert.jsonDecode(strDbc);
        _saveDbcToDataBase(dbcInJson);
        syncMetaDatas(dbcInJson);
        return dbcInJson;
    }

    @override
    Future<Map<String, dynamic>> getDbc() async {
        var storage = LocalStorage('dbc');
        await storage.ready;
        Map<String, dynamic> dbcInJson = storage.getItem('dbc');
        return dbcInJson;
    }

    void _saveDbcToDataBase(Map<String, dynamic> dbcInJson) async {
        var storage = LocalStorage('dbc');
        await storage.ready;
        storage.setItem('dbc', dbcInJson);
    }

    @override
    Future<Map<String, dynamic>> syncMetaDatas(Map<String, dynamic> dbcInJson) async {
        await usb_can.syncMetaDatas(dbcInJson);
        return dbcInJson;
    }

    @override
    void startSending() {
        usb_can.startSending();
    }

    @override
    void stopSending() {
        usb_can.stopSending();
    }

    @override
    void loadAmmo(int id) {
        usb_can.loadAmmo(id);
    }

    @override
    void unloadAmmo(int id) {
        usb_can.unloadAmmo(id);
    }

    @override
    void setConstStrategy(String sname, double value) {
        usb_can.setConstStrategy(sname, value);
    }
}
