package com.ripple182.fluttersqlite;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import io.flutter.view.FlutterView;

import static android.content.ContentValues.TAG;

public class RawSQLiteHelper extends SQLiteOpenHelper
{
    private FlutterView flutterView;

    public RawSQLiteHelper(Context context, FlutterView flutterView, String databaseName, int version)
    {
        super(context, databaseName, null, version);

        this.flutterView = flutterView;
        this.flutterView.addOnMessageListener("rawQuery", rawQuery);
    }

    @Override
    public void onCreate(SQLiteDatabase sqLiteDatabase)
    {
    }

    @Override
    public void onUpgrade(SQLiteDatabase sqLiteDatabase, int i, int i1)
    {
    }

    private final FlutterView.OnMessageListener rawQuery = new FlutterView.OnMessageListener()
    {
        @Override
        public String onMessage(FlutterView flutterView, String s)
        {
            Cursor cursor = getWritableDatabase().rawQuery(s, null);

            return CursorToJSON(cursor).toString();
        }
    };

    private JSONArray CursorToJSON(Cursor cursor)
    {
        JSONArray resultSet = new JSONArray();
        cursor.moveToFirst(); //TODO: exception is nothing returned?
        while (!cursor.isAfterLast())
        {
            int totalColumn = cursor.getColumnCount();
            JSONObject rowObject = new JSONObject();
            for (int i = 0; i < totalColumn; i++)
            {
                if (cursor.getColumnName(i) != null)
                {
                    try
                    {
                        Object colVal = null;

                        switch(cursor.getType(i))
                        {
                            case Cursor.FIELD_TYPE_INTEGER:
                                colVal = cursor.getInt(i);
                                break;
                            case Cursor.FIELD_TYPE_FLOAT:
                                colVal = cursor.getFloat(i);
                                break;
                            case Cursor.FIELD_TYPE_STRING:
                            case Cursor.FIELD_TYPE_BLOB:
                                colVal = cursor.getString(i);
                                break;
                        }

                        rowObject.put(cursor.getColumnName(i), colVal);
                    }
                    catch (Exception e)
                    {
                        Log.d(TAG, e.getMessage());
                    }
                }
            }
            resultSet.put(rowObject);
            cursor.moveToNext();
        }

        cursor.close();
        return resultSet;
    }
}