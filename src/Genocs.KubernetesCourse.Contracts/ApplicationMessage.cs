namespace Genocs.KubernetesCourse.Contracts
{
    public class ApplicationMessage
    {
        public int Id { get; set; }
        public string MessageName { get; set; }
        public int CategoryId { get; set; }
        public virtual Category Category { get; set; }
        public int LevelId { get; set; }
        public virtual Level Level { get; set; }
    }
}