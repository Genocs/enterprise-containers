using Genocs.KubernetesCourse.Contracts;
using System.Collections.Generic;

namespace Genocs.KubernetesCourse.WebApi.Messaging;

public interface ITechTalksEventPublisher
{
    void SendMessages(List<TechTalk> talks);
}