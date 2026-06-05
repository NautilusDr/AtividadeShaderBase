using KinematicCharacterController.Examples;
using UnityEngine;

public class WaterSpeed : MonoBehaviour
{
    private void OnTriggerEnter(Collider other)
    {

        if (other.name == "ExampleCharacter")
        {
            other.gameObject.GetComponent<ExampleCharacterController>().MaxStableMoveSpeed = 5;
        }
    }

    private void OnTriggerExit(Collider other)
    {

        if (other.name == "ExampleCharacter")
        {
            other.gameObject.GetComponent<ExampleCharacterController>().MaxStableMoveSpeed = 10;
        }
    }
}
