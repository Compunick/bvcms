﻿using System.Linq;
using System.Web.Mvc;
using CmsData;
using CmsWeb.Areas.Org.Models;

namespace CmsWeb.Areas.Org.Controllers
{
    [RouteArea("Org", AreaPrefix="MemberDirectory"), Route("{action=index}")]
    public class MemberDirectoryController : CmsController
    {
        [Route("~/MemberDirectory/{id:int}")]
        [Route("~/MemberDirectory/Index/{id:int}")]
        public ActionResult Index(int id)
        {
            if (DbUtil.Db.Organizations.Any(oo => oo.OrganizationId == id && oo.PublishDirectory > 0)
                && (User.IsInRole("Admin") || DbUtil.Db.OrganizationMembers.Any(
                    mm => mm.OrganizationId == id && mm.PeopleId == UtilityExtensions.Util.UserPeopleId)))
                return View(new MemberDirectoryModel(id));
            return RedirectToAction("NoAccess");
        }
        [HttpPost]
        public ActionResult Results(MemberDirectoryModel m)
        {
            if (User.IsInRole("Admin") ||
                DbUtil.Db.OrganizationMembers.Any(
                    mm => mm.OrganizationId == m.OrgId && mm.PeopleId == UtilityExtensions.Util.UserPeopleId))
                return View(m);
            return Content("unauthorized");
        }
        public ActionResult NoAccess()
        {
            return View("NoAccess");
        }
    }
}
