using UnityEngine;

public class DissolveStarter : MonoBehaviour
{
    [SerializeField] MeshRenderer[] CharMaterial;
    [SerializeField] Material[] OtherMaterial;
    [SerializeField] Material Dissolver;
    [SerializeField] Material HullOutline;
    float Porcentagem;
    bool PodeDissolver;

    private void FixedUpdate()
    {
        //Faz o Dissolve ir de 0 a 1 (Min - Max)
        if (PodeDissolver)
        {
            Porcentagem += Time.deltaTime;
            Dissolver.SetFloat("_DissolveAmount", Porcentagem);
        }
    }
    private void OnTriggerEnter(Collider other)
    {
        if (other.name == "ExampleCharacter")
        {
            //Reinicia o valor de Dissolve para evitar boneco desaparecer por uma fração de segundo ao cair no poço de lava de novo
            Porcentagem = 0;
            //Modificar o material para o shader nessecário
            foreach (var c in CharMaterial)
            {
                c.material = Dissolver;
            }
            PodeDissolver = true;

            //Tirar Outline Para não causar problemas visuais
            HullOutline.SetColor("_Tint", new Color(HullOutline.GetColor("_Tint").r, HullOutline.GetColor("_Tint").g, HullOutline.GetColor("_Tint").b, 0));
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.name == "ExampleCharacter")
        {
            for (int i = 0; i < 2; i++)
            {
                CharMaterial[i].material = OtherMaterial[i];
            }
            HullOutline.SetColor("_Tint", new Color(HullOutline.GetColor("_Tint").r, HullOutline.GetColor("_Tint").g, HullOutline.GetColor("_Tint").b, 1));
        }
    }

    private void OnDisable()
    {
        HullOutline.SetColor("_Tint", new Color(HullOutline.GetColor("_Tint").r, HullOutline.GetColor("_Tint").g, HullOutline.GetColor("_Tint").b, 1));
    }
}
