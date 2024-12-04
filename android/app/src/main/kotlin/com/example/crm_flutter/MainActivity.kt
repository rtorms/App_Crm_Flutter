package com.example.crm_flutter
import android.content.Intent
import android.provider.CalendarContract
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.text.SimpleDateFormat
import java.util.*

class MainActivity : FlutterActivity() {
    private val CHANNEL = "crm_flutter_agenda"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "adicionarEvento") {
                val titulo = call.argument<String>("titulo")
                val descricao = call.argument<String>("descricao")
                val inicio = call.argument<String>("inicio")
                val fim = call.argument<String>("fim")

                val dateFormat = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.getDefault())

                val inicioMillis = dateFormat.parse(inicio!!)?.time
                val fimMillis = dateFormat.parse(fim!!)?.time

                if (titulo != null && inicioMillis != null && fimMillis != null) {
                    adicionarEventoNaAgenda(titulo, descricao, inicioMillis, fimMillis)
                    result.success("Evento adicionado com sucesso")
                } else {
                    result.error("ARGUMENT_ERROR", "Parâmetros inválidos", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun adicionarEventoNaAgenda(titulo: String, descricao: String?, inicio: Long, fim: Long) {
        val intent = Intent(Intent.ACTION_INSERT).apply {
            data = CalendarContract.Events.CONTENT_URI
            putExtra(CalendarContract.Events.TITLE, titulo)
            putExtra(CalendarContract.Events.DESCRIPTION, descricao)
            putExtra(CalendarContract.EXTRA_EVENT_BEGIN_TIME, inicio)
            putExtra(CalendarContract.EXTRA_EVENT_END_TIME, fim)
        }
        startActivity(intent)
    }
}
