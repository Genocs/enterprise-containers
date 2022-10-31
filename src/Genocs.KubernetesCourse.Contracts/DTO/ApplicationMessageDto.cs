namespace Genocs.KubernetesCourse.Contracts.DTO
{
    public class ApplicationMessageDto
    {
        public int Id { get; set; }
        public string MessageName { get; set; }
        public int CategoryId { get; set; }
        public string CategoryName { get; set; }
        public int LevelId { get; set; }
        public string LevelName { get; set; }
    }
}