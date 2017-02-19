import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';

abstract class SQLiteDatabase
{
    final String DATABASE_EXIST = "SELECT count(*) AS db_version_exists FROM sqlite_master WHERE type='table' AND name='DB_VERSION';";
    final String CREATE_VERSION_TABLE = "CREATE TABLE IF NOT EXISTS DB_VERSION (db_version INTEGER);";
    final String INSERT_VERSION = "INSERT INTO DB_VERSION VALUES (1);";
    final String SELECT_VERSION = "SELECT db_version FROM DB_VERSION;";
    final String UPDATE_VERSION = "UPDATE DB_VERSION SET db_version = {0} where db_version = {1};";

    SQLiteDatabase();

    Future init(String databaseName, int version)
    async
    {
        await PlatformMessages.sendString("initDatabase", databaseName);

        String json = await query(DATABASE_EXIST);

        List list = JSON.decode(json);

        bool exists = list[0]["db_version_exists"].toString() == "1";

        int oldVersion = 1;

        //if the table DB_VERSION does not exist then we need to create DB from scratch
        if (!exists)
        {
            await query(CREATE_VERSION_TABLE);
            await query(INSERT_VERSION);

            //run user's create database
            createDatabase();
        }
        else
        {
            json = await query(SELECT_VERSION);

            list = JSON.decode(json);

            oldVersion = int.parse(list[0]["db_version"]);
        }

        //if the current database version does not match the user's current version then run updates
        if (version > oldVersion)
        {
            updateDatabase(oldVersion, version);

            await query(UPDATE_VERSION.replaceAll("{0}", version.toString()).replaceAll("{1}", oldVersion.toString()));
        }
    }

    Future<String> query(String query)
    {
        if (query != null && query.isNotEmpty)
        {
            return PlatformMessages.sendString("rawQuery", query);
        }

        return new Future<String>.value("[]");
    }

    void createDatabase();

    void updateDatabase(int oldVersion, int newVersion);
}