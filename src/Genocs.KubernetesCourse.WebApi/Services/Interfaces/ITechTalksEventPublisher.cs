using Genocs.KubernetesCourse.Contracts;

namespace Genocs.KubernetesCourse.WebApi.Services.Interfaces;

public interface ITechTalksEventPublisher
{
    void SendMessages(List<TechTalk> talks);
}