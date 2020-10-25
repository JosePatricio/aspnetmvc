using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web.Mvc;
using aspnetchallenge.Models;
using Newtonsoft.Json;

namespace aspnetchallenge.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            using (challengedbEntities entities = new challengedbEntities())
            {
                List<Atencion> lista = entities.spObtenerAtencionesEnCola("cola1").ToList();
                lista.Insert(0,new Atencion());
                return View(lista.ToList());
            }
        }


        [HttpGet]
        public ActionResult Cola2()
        {
            using (challengedbEntities entities = new challengedbEntities())
            {
                List<Atencion> lista = entities.spObtenerAtencionesEnCola("cola2").ToList();
                lista.Insert(0, new Atencion());
                JsonSerializerSettings jss = new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore };
                return Json(new { Success = true, data = JsonConvert.SerializeObject(lista, Formatting.Indented, jss) }, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpGet]
        public ActionResult TiposAtencion()
        {
            using (challengedbEntities entities = new challengedbEntities())
            {
                List<TipoAtencion> lista = entities.spObtenerTiposAtencion().ToList();
                JsonSerializerSettings jss = new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore };
                return Json(new { Success = true, data = JsonConvert.SerializeObject(lista, Formatting.Indented, jss) }, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        public JsonResult Insertar(Atencion atencion)
        {
            using (challengedbEntities entities = new challengedbEntities())
            {
                List<Atencion> lista = null;
                ObjectParameter EstadoParametro = new ObjectParameter("Estado", typeof(bool));
                ObjectParameter MensajeParametro = new ObjectParameter("Mensaje", typeof(string));

                entities.spInsertarTurno(atencion.Id, atencion.NombreCliente, atencion.CodigoTipo, EstadoParametro, MensajeParametro);

                bool estado = Convert.ToBoolean(EstadoParametro.Value);
                string mensaje = Convert.ToString(MensajeParametro.Value);

                if (estado) {
                    lista = entities.spObtenerAtencionesEnCola(atencion.CodigoTipo).ToList();
                }

                JsonSerializerSettings jss = new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore };
                return Json(new { Estado= estado, Mensaje= mensaje,  data = JsonConvert.SerializeObject(lista, Formatting.Indented, jss) }, JsonRequestBehavior.AllowGet);

            }
        }




    }
}