namespace Genocs.KubernetesCourse.Worker.Messaging;

public interface ITechTalksEventConsumer
{
    void Initialize();
    public void Close();
}