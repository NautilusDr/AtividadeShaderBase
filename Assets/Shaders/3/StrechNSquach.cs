using UnityEngine;

public class StrechNSquach : MonoBehaviour
{
    [SerializeField] Material Strech;
    [SerializeField] Material OutlineStrech;
    float CurrentYPos;
    float LastYPos;
    private void Awake()
    {
        CurrentYPos = transform.position.y;
    }

    private void FixedUpdate()
    {
        SpeedStrech();
    }
    void SpeedStrech()
    {
        LastYPos = CurrentYPos;
        CurrentYPos = transform.position.y;
        switch (LastYPos - CurrentYPos)
        {
            case < -0.05f:
                Strech.SetFloat("_Velocity", 1 + ((LastYPos - CurrentYPos) * .75f));
                break;
            case > .05f:
                Strech.SetFloat("_Velocity", 1 + ((LastYPos - CurrentYPos) * .5f));
                break;
            default:
                Strech.SetFloat("_Velocity", 1);
                break;

        }

        if (Strech.GetFloat("_Velocity") < .75f)
        {
            Strech.SetFloat("_Velocity", .75f);
        }
        else if (Strech.GetFloat("_Velocity") > 1.25f)
        {
            Strech.SetFloat("_Velocity", 1.25f);
        }
        //Evitar problemas visuais com a Outline;
        OutlineStrech.SetFloat("_YSize", Strech.GetFloat("_Velocity"));
    }
}
